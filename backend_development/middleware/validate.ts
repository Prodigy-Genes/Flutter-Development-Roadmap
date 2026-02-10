import type{ Request,Response, NextFunction  } from "express";
import * as z from "zod";

export const validate = ( schema: z.ZodTypeAny ) => 
    async(req: Request, res: Response, next: NextFunction) => {
        try {
            // parsse the body against the schema
            await schema.parseAsync({
                body: req.body,
                query: req.query,
                params: req.params
            });
            next();
        }catch(e){
            if (e instanceof z.ZodError) {
                return res.status(400).json({
                    status: 'error',
                    errors: e.issues.map(e => ({
                        field: e.path[1] || e.path[0],
                        message: e.message
                    }))
                    
                });
            } 
            next(e);
        }
    }

