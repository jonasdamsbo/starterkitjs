import { Routes } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { ExampleListComponent } from './example/components/example-list/example-list.component';
import { ExampleCreateComponent } from './example/components/example-create/example-create.component';
import { ExampleUpdateComponent } from './example/components/example-update/example-update.component';
import { ExampleDeleteComponent } from './example/components/example-delete/example-delete.component';

export const routes: Routes = [
    { path: '', component: HomeComponent },
    { path: 'all', component: ExampleListComponent },
    { path: 'create', component: ExampleCreateComponent },
    { path: 'update/:id', component: ExampleUpdateComponent },
    { path: 'delete/:id', component: ExampleDeleteComponent }
];
