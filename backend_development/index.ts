import express from 'express';
import userRouter from './auth.js';
import taskRouter from './tasks.js';
import pool from './db.js'; 
import { errorHandler } from './middleware/errorHandler.js';
import rateLimit from 'express-rate-limit';
import logger from './logger.js';
import { env } from './utils/env.js';
import helmet from 'helmet';
import cors from 'cors';


const app = express();

// Security Middleware
app.use(helmet());
app.use(cors({
    origin: env.NODE_ENV === 'production' ? 'domain-placeholder.com' : '*', 
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization']
}))


const PORT = env.PORT;

// Throughput control
const limiter = rateLimit({
    windowMs : 15 * 60 * 1000, // 15 minutes
    max : 100, // Limit each IP to 100 requests per `window` (here, per 15 minutes)
    message: 'Hold on!, Too many requests!'

});

app.use(limiter);

app.use(express.json());

// health Route
app.get('/health', async (req, res) => {
    try {
        await pool.query('SELECT 1');
        res.status(200).json({ status: 'healthy', db: 'connected', uptime: process.uptime() });
    } catch (err) {
        res.status(503).json({ status: 'unhealthy', db: 'disconnected' });
    }
});

// Routes
app.use('/auth', userRouter);
app.use('/api', taskRouter);

// Error Handler
app.use(errorHandler);

// Server
async function startServer() {
    try {
        // Test DB Connection
        const res = await pool.query('SELECT NOW()');
        logger.info('Connected to Supabase:', res.rows[0].now);

        const server = app.listen(env.PORT, () => {
            logger.info(`Server live in ${env.NODE_ENV} mode at http://localhost:${env.PORT}`);
        });

        // Graceful Shutdown
        process.on('SIGTERM', () => {
            logger.info('SIGTERM received. Closing HTTP server...');
            server.close(async () => {
                await pool.end();
                logger.info('HTTP server and DB pool closed.');
                process.exit(0);
            });
        });

    } catch (err) {
        logger.error('Failed to start server:', err);
        process.exit(1);
    }
}

startServer();