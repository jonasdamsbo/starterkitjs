import { 
  getAllExamples,
  getExample,
  createExample,
  updateExample,
  deleteExample, 
} from '../repositories/examplesRepository';

import {v4 as uuidv4} from 'uuid';

export const fetchExamples = async () => {
  return getAllExamples();
};

export const fetchExampleById = async (id: string) => {
  return getExample(id);
};

export const addExample = async (data: { id: string;title: string; description: string }) => {
  data.id = uuidv4();
  return createExample(data);
};

export const editExample = async (id: string, data: { title?: string; description?: string }) => {
  return updateExample(id, data);
};

export const removeExample = async (id: string) => {
  return deleteExample(id);
};