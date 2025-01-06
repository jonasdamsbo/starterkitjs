import { Router } from 'express';
import cors from 'cors';
import {
    getExamples,
    getExample,
    createExample,
    updateExample,
    deleteExample,
  } from '../controllers/examplesController';

const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient({
  log: ['query', 'info', 'warn', 'error'],
});

const router = Router();

router.get('/ExampleModel', cors(), getExamples);           // Fetch all examples
router.get('/ExampleModel/:id', cors(), getExample);        // Fetch example by ID
router.post('/ExampleModel', cors(), createExample);        // Create a new example
router.put('/ExampleModel/:id', cors(), updateExample);     // Update an example by ID
router.delete('/ExampleModel/:id', cors(), deleteExample);  // Delete an example by ID

export default router;