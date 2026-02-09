import type {NextFunction, Request, Response } from 'express';
import pool from './db.js';
import { authGate } from './users.js';
import type{ AuthRequest } from './users.js';
import { Router } from 'express';
import { AppError, asyncHandler } from './utils.js';


interface Task{
    id: number;
    title: string;
    description: string | null;
    completed: boolean;
}

interface TaskWithCount extends Task{
    total_count: number;
}

const router : Router = Router();
const PORT = 3000;


// Fetching tasks from the table
router.get('/tasks', authGate, asyncHandler( async(req: AuthRequest, res: Response) => {

    const page = parseInt(req.query.page as string) || 1;
    const limit = parseInt(req.query.limit as string) || 10;

    // Calculate the offset
    const offset = (page - 1) * limit;

    const userId = req.user?.userId;
    const result = await pool.query<TaskWithCount>(
        'SELECT *, COUNT(*) OVER() AS total_count FROM tasks WHERE user_id = $1 ORDER BY id ASC LIMIT $2 OFFSET $3', [userId, limit, offset]
    );
    
    // We can grab the total count from the first row (if there are any rows)
    const totalItems = result.rows[0]?.total_count ?? 0;

    if(result.rows.length === 0){
        throw new AppError('No tasks found', 404);
    }        
    res.status(200).json({
        page,
        limit,
        data: result.rows
    });
    
}));

// Fetching a single task
router.get('/tasks/:id', authGate, asyncHandler(async(req: AuthRequest, res: Response) => {
    const id = parseInt(req.params.id as string);
    const userId = req.user?.userId;

        const query = 'SELECT * FROM tasks WHERE user_id =$1 AND id = $2';

        const result = await pool.query<Task>(query, [userId, id]);
        
        if(result.rows.length === 0){
            throw new AppError('Task not found', 404);
        }

        res.status(200).json(result.rows[0]);
    
}))

// Adding tasks to the table on supabase
router.post('/tasks', authGate,  asyncHandler(async(req: AuthRequest,  res: Response) => {
    const {title, description} = req.body;

    if(!title || title.trim === ''){
        throw new AppError('Title is required', 400);
    }

    const userId = req.user?.userId;
        const query = 'INSERT INTO tasks (title, description, user_id)  VALUES ($1, $2, $3 ) RETURNING *';
        
        const result = await pool.query<Task>(query, [title, description, userId]);
    

        res.status(201).json(result.rows[0]);
}));

// Update tasks
router.put('/tasks/:id', authGate, asyncHandler(async(req: AuthRequest, res: Response) => {
    const id = parseInt(req.params.id as string);
    const {title, description, completed} = req.body;
    const userId = req.user?.userId;

      const query = 'UPDATE tasks SET title = $1, description = $2, completed = $3 WHERE user_id = $4 AND id = $5 RETURNING *'

      const result = await pool.query<Task>(query, [title, description, completed, userId, id]);
      if(result.rows.length === 0){
        throw new AppError('Task not found', 404);
      }

      res.status(200).json(result.rows[0]);
}));


// Delete a task
router.delete('/tasks/:id', authGate, asyncHandler(async(req: AuthRequest, res: Response) => {
    const id = parseInt(req.params.id as string);
    const userId = req.user?.userId;
      const query = 'DELETE FROM tasks WHERE user_id = $1 AND id = $2 RETURNING *';

      const result = await pool.query<Task>(query, [userId,id]);

      if(result.rows.length === 0){
        throw new AppError('Task not found', 404);
      }

      res.status(200).json({message:'Task deleted successfully', result: result.rows[0]});

}));

export default router