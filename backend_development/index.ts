import express from 'express';
import type {Request, Response, NextFunction, Express } from 'express';
import helmet from 'helmet';
import cors from 'cors';
import dotenv from 'dotenv';
import pg from 'pg';
import  authRouter  from './auth.js';
import taskRouter from './tasks.js';
import { errorHandler } from './middleware/errorHandler.js';

dotenv.config();

const app : Express = express();

// --- DATABASE CONNECTION ---
// In Serverless, we create the pool outside the handler to allow for connection reuse
export const pool = new pg.Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
  max: 10, // Lower limit for Serverless to avoid exhausting Supabase connections
  idleTimeoutMillis: 30000,
});

// --- MIDDLEWARE ---
app.use(helmet());
app.use(cors({
  origin: process.env.NODE_ENV === 'production' ? ['https://your-flutter-web-app.com'] : '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
}));
app.use(express.json());

// --- ROUTES ---
app.get('/health', async (req: Request, res: Response) => {
  try {
    await pool.query('SELECT 1');
    res.status(200).json({ status: 'healthy', timestamp: new Date().toISOString() });
  } catch (err) {
    res.status(503).json({ status: 'unhealthy', error: 'Database unreachable' });
  }
});

app.use('/auth', authRouter);
app.use('/api/tasks', taskRouter);

// --- ERROR HANDLING ---
app.use(errorHandler);

// --- VERCEL EXPORT ---
// This is the critical change for Vercel. 
// Vercel handles the "listening" part automatically.
export default app;

// --- LOCAL DEVELOPMENT ---
// Only start the server manually if we are not running in a serverless environment
if (process.env.NODE_ENV !== 'production') {
  const PORT = process.env.PORT || 3000;
  app.listen(PORT, () => {
    console.log(`Development server active on http://localhost:${PORT}`);
  });
}