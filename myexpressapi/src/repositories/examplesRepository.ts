//import prisma from '../database/connection';
//const { PrismaClient } = require('@prisma/client');
import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient({
  log: ['query', 'info', 'warn', 'error'],
});
import { Example } from '@prisma/client';

export const getAllExamples = async (): Promise<Example[]> => {
  return prisma.example.findMany();
};

export const getExample = async (id: string): Promise<Example | null> => {
  return prisma.example.findUnique({
    where: { id },
  });
};

export const createExample = async (data: { title: string; description: string }): Promise<Example> => {
  return prisma.example.create({
    data,
  });
};

export const updateExample = async (id: string, data: { title?: string; description?: string }): Promise<Example | null> => {
  return prisma.example.update({
    where: { id },
    data,
  });
};

export const deleteExample = async (id: string): Promise<Example | null> => {
  return prisma.example.delete({
    where: { id },
  });
};