import type { Request, Response, NextFunction } from 'express';

// This function throws a report about what error is being caught
export class AppError extends Error{
    // 'statusCode' helps our Safety Net know which HTTP code to send (401, 404, etc.)
    constructor(public message:  string, public statusCode: number ){
        super(message);
        this.name = 'AppError';
        // This captures the stack trace so we know where exactly the error is happening
        Error.captureStackTrace(this, this.constructor);
    }
}

// It runs in async functions which alerts the AppError about an error in the function
export const asyncHandler = (fn : Function) => (req: Request, res: Response, next: NextFunction) => {
    //  We execute a particular function, catch and pass any errors to 'next'
    Promise.resolve(fn(req, res, next)).catch(next)
}