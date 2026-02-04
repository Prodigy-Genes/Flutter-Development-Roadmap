import express from 'express';
import type {Request, Response } from 'express';
import pool from './db.js';

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

const app = express();

const PORT = 3000;

const Middleware = express.json();

app.use(Middleware);

// Fetching tasks from the table
app.get('/tasks', async(req: Request, res: Response) => {
    try{
        const result = await pool.query('SELECT * FROM tasks ORDER BY id ASC');
        res.status(200).json(result.rows);
        
    }catch(e){
        console.error(e);
        res.status(500).json({error: 'Internal Server Error'});
    }
})

// Fetching a single task
app.get('/tasks/:id', async(req: Request, res: Response) => {
    const id = parseInt(req.params.id as string);

    try{
        const query = 'SELECT * FROM tasks WHERE id = $1';

        const result = await pool.query(query, [id]);
        
        if(result.rows.length === 0){
            res.status(404).json({error: 'Task not found'});
        }

        res.status(200).json(result.rows[0]);
    }catch(e){
        console.error(e);
        res.status(500).json({error: 'Internal Server Error'});

    }
})

// Adding tasks to the table on supabase
app.post('/tasks', async(req: Request,  res: Response) => {
    const {title, description} = req.body;
    try{
        const query = 'INSERT INTO tasks (title, description) VALUES ($1, $2) RETURNING *';
        
        const result = await pool.query(query, [title, description]);

        res.status(201).json(result.rows[0]);
    }catch(e){
        console.error(e);
        res.status(500).json({error: 'FAILED TO CREATE TASK'});
    }
});

// Update tasks
app.put('/tasks/:id', async(req: Request, res: Response) => {
    const id = parseInt(req.params.id as string);
    const {title, description, completed} = req.body;

    try{
      const query = 'UPDATE tasks SET title = $1, description = $2, completed = $3 WHERE id = $4 RETURNING *'

      const result = await pool.query(query, [title, description, completed, id]);
      if(result.rows.length === 0){
        res.status(404).json({error: 'Task not found'})
      }

      res.status(200).json(result.rows[0]);
    }catch(e){
        console.error(e);
        res.status(500).json({error: 'FAILED TO UPDATE TASK'})
    }
})

app.listen(PORT, () => {
    console.log('Server is running')
})

// Delete a task
app.delete('/tasks/:id', async(req: Request, res: Response) => {
    const id = parseInt(req.params.id as string);
    try{
      const query = 'DELETE FROM tasks WHERE id = $1 RETURNING *';

      const result = await pool.query(query, [id]);

      if(result.rows.length === 0){
        res.status(404).json({error: 'Task not found'});
      }

      res.status(200).json({message:'Task deleted successfully', result: result.rows[0]});
    }catch(e){
        console.error(e);
        res.status(500).json({error: 'FAILED TO DELETE TASK'});

    }
})