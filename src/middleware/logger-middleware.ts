import { Request, Response, NextFunction } from 'express';

export const loggerMiddleware = (req: Request, res: Response, next: NextFunction): void => {
    const log = {
        method: req.method,
        url: req.url,
        headers: req.headers,
        query: req.query,
        body: req.body,
        timestamp: new Date().toISOString()
    };
    console.log(JSON.stringify(log));
    next();
};