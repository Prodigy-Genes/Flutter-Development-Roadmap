import express from 'express';
import userRouter from './users.js';
import taskRouter from './tasks.js';
import pool from './db.js'; 
import { errorHandler } from './middleware/errorHandler.js';
import rateLimit from 'express-rate-limit';
import logger from './logger.js';

const app = express();
const PORT = process.env.PORT || 3000;

const limiter = rateLimit({
    windowMs : 15 * 60 * 1000, // 15 minutes
    max : 100, // Limit each IP to 100 requests per `window` (here, per 15 minutes)
    message: 'Hold on!, Too many requests!'

});

app.use(limiter);

app.use(express.json());

// 1. Connect to the SUPABASE Database
async function startServer() {
    try {
        const res = await pool.query('SELECT NOW()');
        logger.info('Connected to Supabase:', res.rows[0].now);

        // 2. Mount Routers
        app.use('/auth', userRouter);
        app.use('/api', taskRouter);

        app.use(errorHandler);


        // 3. Start Listening
        app.listen(PORT, () => {
            logger.info(`Server is live at http://localhost:${PORT}`);
        });
    } catch (err) {
        logger.error('Database connection failed:', err);
    }
}

startServer();