import express from 'express';
import type { Request, Response } from 'express';

interface Task {
    id: number;
    title: string;
    description: string | null;
    completed: boolean;
}

let tasks : Task[] = [
    { id: 1, title: "Sample Task", description: "This is a sample task", completed: false},
    { id: 2, title: "Another Task", description:null, completed: true}
]

// Create an Express application
const app = express();

// Define the PORT number
const PORT = 3000;

// Middleware to parse JSON bodies
app.use(express.json());

// Start the server and listen on the specified PORT

app.get('/', (req: Request, res: Response) => {
    res.send("Typescript Express Server is running!");
});

app.listen(PORT, () =>{
    console.log(`Server is running at http://localhost:${PORT}`);
})