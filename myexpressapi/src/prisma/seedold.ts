import { PrismaClient } from '@prisma/client';
import { v4 as uuidv4 } from 'uuid'; // Import uuid package
import { execSync } from 'child_process'; // To run shell commands for migrations

const prisma = new PrismaClient();

async function seedDatabase(): Promise<void> {
    console.log('started');
    try {
        
        // Check if the 'Example' table exists
        const result = await prisma.$queryRaw`
            SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Example' AND TABLE_SCHEMA = 'dbo'
        `;
        const typedResult = result as { TABLE_NAME: string }[];

        // Run migrations to ensure the latest schema is applied
        console.log('Running migrations...');
        execSync('npx prisma migrate deploy', { stdio: 'inherit' });

        // If the table does not exist, the result will be null
        if (typedResult.length === 0) {
            console.log('Table "Example" does not exist, seeding data...');

            // Seed the database (with UUID as id)
            await prisma.example.create({
                data: {
                    id: uuidv4(), // Generate a UUID for the id
                    title: 'Example Name',
                    description: 'This is an example seed data with UUID as the ID.',
                },
            });
            console.log('Table "Example" dummy data inserted');
        } else {
            console.log('Table "Example" exists, skipping seeding.');
        }
    } catch (error) {
        console.error('Error during the seeding process:', error);
        process.exit(1)
    } finally {
        // Ensure the Prisma client is disconnected after the operations
        await prisma.$disconnect();
    }
}

export default seedDatabase;