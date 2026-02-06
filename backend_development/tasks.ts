import type {Request, Response } from 'express';
import pool from './db.js';
import { authGate } from './users.js';
import type{ AuthRequest } from './users.js';
import { Router } from 'express';


interface Task{
    id: number;
    title: string;
    description: string | null;
    completed: boolean;
}

async function  checkDatabase(){
    try{
        const result = await pool.query('SELECT NOW()');
        console.log('CONNECTED TO SUPABASE DATABASE TIME : ', result.rows[0].now);
    }catch(e){
        console.log('DATABASE CONNECTION FAILED : ', e);
    }
}

checkDatabase();

const router : Router = Router();
const PORT = 3000;


// Fetching tasks from the table
router.get('/tasks', authGate, async(req: AuthRequest, res: Response) => {
    const userId = req.user?.userId;
    try{
        const result = await pool.query<Task>('SELECT * FROM tasks WHERE user_id = $1 ORDER BY id ASC', [userId]);
        res.status(200).json(result.rows);
        
    }catch(e){
        console.error(e);
        res.status(500).json({error: 'Internal Server Error'});
    }
})

// Fetching a single task
router.get('/tasks/:id', authGate, async(req: AuthRequest, res: Response) => {
    const id = parseInt(req.params.id as string);
    const userId = req.user?.userId;

    try{
        const query = 'SELECT * FROM tasks WHERE user_id =$1 AND id = $2';

        const result = await pool.query<Task>(query, [userId, id]);
        
        if(result.rows.length === 0){
            return res.status(404).json({error: 'Task not found'});
        }

        res.status(200).json(result.rows[0]);
    }catch(e){
        console.error(e);
        res.status(500).json({error: 'Internal Server Error'});

    }
})

// Adding tasks to the table on supabase
router.post('/tasks', authGate, async(req: AuthRequest,  res: Response) => {
    const {title, description} = req.body;
    const userId = req.user?.userId;
    try{
        const query = 'INSERT INTO tasks (title, description, user_id)  VALUES ($1, $2, $3 ) RETURNING *';
        
        const result = await pool.query<Task>(query, [title, description, userId]);

        res.status(201).json(result.rows[0]);
    }catch(e){
        console.error(e);
        res.status(500).json({error: 'FAILED TO CREATE TASK'});
    }
});

// Update tasks
router.put('/tasks/:id', authGate, async(req: AuthRequest, res: Response) => {
    const id = parseInt(req.params.id as string);
    const {title, description, completed} = req.body;
    const userId = req.user?.userId;

    try{
      const query = 'UPDATE tasks SET title = $1, description = $2, completed = $3 WHERE user_id = $4 AND id = $5 RETURNING *'

      const result = await pool.query<Task>(query, [title, description, completed, userId, id]);
      if(result.rows.length === 0){
        return res.status(404).json({error: 'Task not found'})
      }

      res.status(200).json(result.rows[0]);
    }catch(e){
        console.error(e);
        res.status(500).json({error: 'FAILED TO UPDATE TASK'})
    }
})


// Delete a task
router.delete('/tasks/:id', authGate, async(req: AuthRequest, res: Response) => {
    const id = parseInt(req.params.id as string);
    const userId = req.user?.userId;
    try{
      const query = 'DELETE FROM tasks WHERE user_id = $1 AND id = $2 RETURNING *';

      const result = await pool.query<Task>(query, [userId,id]);

      if(result.rows.length === 0){
        return res.status(404).json({error: 'Task not found'});
      }

      res.status(200).json({message:'Task deleted successfully', result: result.rows[0]});
    }catch(e){
        console.error(e);
        res.status(500).json({error: 'FAILED TO DELETE TASK'});

    }
})

export default router