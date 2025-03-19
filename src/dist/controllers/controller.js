"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CombinedController = void 0;
class CombinedController {
    getHelloWorld(req, res) {
        res.status(200).json({ message: "Hello World!" });
    }
    getCurrentTime(req, res) {
        const name = req.query.name || "Guest";
        const timestamp = Math.floor(Date.now() / 1000);
        res.status(200).json({ timestamp, message: `Hello ${name}` });
    }
    healthCheck(req, res) {
        res.status(200).send();
    }
}
exports.CombinedController = CombinedController;
