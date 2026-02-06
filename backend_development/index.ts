import express from 'express';
import userRouter from './users.js';
import taskRouter from './tasks.js';
import pool from './db.js'; 

const app = express();
const PORT = 3000;

app.use(express.json());

// 1. Connect to the SUPABASE Database
async function startServer() {
    try {
        const res = await pool.query('SELECT NOW()');
        console.log('Connected to Supabase:', res.rows[0].now);

        // 2. Mount Routers
        app.use('/auth', userRouter);
        app.use('/api', taskRouter);

        // 3. Start Listening
        app.listen(PORT, () => {
            console.log(`Server is live at http://localhost:${PORT}`);
        });
    } catch (err) {
        console.error('Database connection failed:', err);
    }
}

startServer();