import express from 'express';
import examplesRoutes from './routes/examplesRoutes';

import cors from 'cors';

//import seedDatabase from './prisma/seed'; // Import the seeding logic

const app = express();
//const PORT = process.env.PORT || 3000;
const PORT = process.env.PORT || 8080;

// Enable CORS for all origins
app.use(cors({
  origin: 'http://localhost:4200', // Allow requests from this origin
  methods: 'GET,POST,PUT,DELETE,OPTIONS', // Allow these methods
  allowedHeaders: 'Content-Type,Authorization', // Allow these headers
}));
  
// Ensure preflight requests are handled
app.options('*', cors());

app.use(express.json());
app.use('/api', examplesRoutes);

// migrate and seed
// async function migrate() {
//   try {
//     console.log("Start migrate and seed db");
//     await seedDatabase();
//     console.log('Migrate and Seeding completed.');
//   } catch (error) {
//     console.error('Migrate and Seeding failed:', error);
//     process.exit(1);
//   }
// }

function main() {
  if(process.env.ENVIRONMENT == "PRODUCTION")
  {

  } 
  else
  {

  }
  
  //migrate();
}
main();

app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});