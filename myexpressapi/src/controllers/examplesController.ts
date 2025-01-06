import { Request, Response } from 'express';
import {
  fetchExamples,
  fetchExampleById,
  addExample,
  editExample,
  removeExample,
} from '../services/examplesService';

export const getExamples = async (req: Request, res: Response) => {
  try {
    const examples = await fetchExamples();
    res.json(examples);
  } catch (error) {
    console.error("Prisma Initialization Error:", error);
    res.status(500).json({ message: error });
  }
};

export const getExample = async (req: Request, res: Response) => {
  const id = String(req.params.id);
  try {
    const example = await fetchExampleById(id);
    if (!example) {
      return res.status(404).json({ message: 'Example not found' });
    }
    res.json(example);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching example' });
  }
};

export const createExample = async (req: Request, res: Response) => {
  try {
    const example = await addExample(req.body);
    res.status(201).json(example);
  } catch (error) {
    res.status(500).json({ message: 'Error creating example' });
  }
};

export const updateExample = async (req: Request, res: Response) => {
  const id = String(req.params.id);
  try {
    const example = await editExample(id, req.body);
    res.json(example);
  } catch (error) {
    res.status(500).json({ message: 'Error updating example' });
  }
};

export const deleteExample = async (req: Request, res: Response) => {
  const id = String(req.params.id);
  try {
    const example = await removeExample(id);
    res.json(example);
  } catch (error) {
    res.status(500).json({ message: 'Error deleting example' });
  }
};