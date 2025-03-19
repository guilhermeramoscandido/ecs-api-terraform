import { Request, Response } from 'express';

export class CombinedController {
    public getHelloWorld(req: Request, res: Response): void {
        res.status(200).json({ message: "Hello World!" });
    }

    public getCurrentTime(req: Request, res: Response): void {
        const name = req.query.name || "Guest";
        const timestamp = Math.floor(Date.now() / 1000);
        res.status(200).json({ timestamp, message: `Hello ${name}` });
    }

    public healthCheck(req: Request, res: Response): void {
        res.status(200).send();
    }
}