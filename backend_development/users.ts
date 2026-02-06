import bcrypt from "bcrypt";
import type { NextFunction, Request, Response } from 'express';
import pool from './db.js';
import jwt from 'jsonwebtoken';
import { Router } from "express";

interface User{
    id: number;
    email: string;
    password_hash: string;
    created_at: Date;
}

// Define what a decoded JWT Payload looks like
interface JWTPayload{
    userId: number;
    email: string;
}

// Extend the Express Request to include our user data 
export interface AuthRequest extends Request{
    user?: JWTPayload;
}

async function checkDatabase(){
    try{
        const result = await pool.query('SELECT NOW()');
        console.log('CONNECTED TO SUPABASE DATABASE TIME :', result.rows[0].now);
    }catch(e){
        console.log('DATABASE CONNECTION FAILED : ', e);
    }
}

checkDatabase();


const router : Router = Router();
const PORT = 5000;


export const  authGate = (req: AuthRequest, res: Response, next: NextFunction) => {
    // Request the Bearer Token
    const authHeader = req.headers['authorization'];
    // Take the actual token
    const token = authHeader?.split(' ')[1];
    
    // Verify the token
    jwt.verify(token as string, process.env.JWT_SECRET as string, (err, decoded) => {
        if(err){
            return res.status(403).json({error: 'Invalid token'});
        }

        // If its valid, we attach the user data to the request
        req.user = decoded as JWTPayload;
        next();
    })
} 

// Signup endpoint
router.post('/signup', async (req: Request, res: Response) => {
    const { email, password } = req.body;

    if(!email || !password){
        return res.status(404).json({error: 'Email and password are required'})
    }

    try {
        const hashedPassword = await bcrypt.hash(password,10);

        // Save to postgres
        const query = 'INSERT INTO users (email, password_hash) VALUES ($1, $2) RETURNING *';
        const result = await pool.query<User>(query, [email, hashedPassword]);

        res.status(201).json({message: 'User created successfully'});
    }catch(e){
        console.error(e);
        res.status(500).json({error: 'FAILED TO CREATE USER'});
    }
})


// login endpoint
router.post('/login', async(req: Request, res: Response) =>{
    const {email, password} = req.body;

    try{
        const query = 'SELECT * FROM users WHERE email = $1';
        const result = await pool.query<User>(query, [email]);
        const user = result.rows[0];
        
        if(!user){
            console.log('User not found');
            return res.status(404).json({error: 'User not found'})
        }

        // Compare the plain password with the hashed one
        const isPasswordValid = await bcrypt.compare(password, user?.password_hash as string);

        if(!isPasswordValid) {
             return res.status(401).json({error: 'Invalid credentials'});
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

export default router;