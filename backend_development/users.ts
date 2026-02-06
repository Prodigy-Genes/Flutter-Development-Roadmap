import bcrypt from "bcrypt";
import express from 'express';
import type { Request, Response } from 'express';
import pool from './db.js';
import jwt from 'jsonwebtoken';

interface User{
    id: number;
    email: string;
    password: string;
    created_at: Date;
}

const app = express();

const PORT = 3000;

const Middleware = express.json();

app.use(Middleware);

// Signup endpoint
app.post('/signup', async (req: Request, res: Response) => {
    const { email, password } = req.body;

    try {
        const hashedPassword = await bcrypt.hash(password,10);

        // Save to postgres
        const query = 'INSERT INTO users (email, password) VALUES ($1, $2) RETURNING *';
        const result = await pool.query<User>(query, [email, hashedPassword]);

        res.status(201).json({message: 'User created successfully', user: result.rows[0]});
    }catch(e){
        console.error(e);
        res.status(500).json({error: 'FAILED TO CREATE USER'});
    }
})


// login endpoint
app.post('/login', async(req: Request, res: Response) =>{
    const {email, password} = req.body;

    try{
        const query = 'SELECT * FROM users WHERE email = $1';
        const result = await pool.query<User>(query, [email]);
        const user = result.rows[0];
        
        if(!user){
            console.log('User not found');
            res.status(404).json({error: 'User not found'})
        }

        // Compare the plain password with the hashed one
        const isPasswordValid = await bcrypt.compare(password, user?.password as string);

        if(!isPasswordValid) {
             res.status(401).json({error: 'Invalid credentials'});
        }

        // Create the JWT
        const token = jwt.sign(
            {userId: user?.id, email: user?.email},
            process.env.JWT_SECRET as string,
            {expiresIn: '1h'}
        );

        res.json({message: 'Login successful', token});
    }catch(e){
        res.status(500).json({error: 'Internal Server Error'})
    }
})

app.listen(PORT, () => {
    console.log('Server is running')
})