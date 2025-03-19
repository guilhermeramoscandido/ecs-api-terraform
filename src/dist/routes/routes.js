"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const controller_1 = require("../controllers/controller");
const router = (0, express_1.Router)();
const combinedController = new controller_1.CombinedController();
router.get('/hello_world', combinedController.getHelloWorld.bind(combinedController));
router.get('/current_time', combinedController.getCurrentTime.bind(combinedController));
router.get('/healthcheck', combinedController.healthCheck.bind(combinedController));
// Middleware to handle unknown routes
router.use((req, res, next) => {
    res.status(404).json({ error: "Route not found" });
});
exports.default = router;
