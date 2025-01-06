import { Component } from '@angular/core';
import { ExampleService } from '../../services/example.service';
import { Example } from '../../models/example.model';
import { FormsModule } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router';
import { HttpClientModule } from '@angular/common/http';

@Component({
  selector: 'app-example-create',
  templateUrl: './example-create.component.html',
  styleUrls: ['./example-create.component.css'],
  imports: [FormsModule, HttpClientModule],
  providers: [ExampleService],
})
export class ExampleCreateComponent {
  example: Example = {id: "0"};

  constructor(
    private exampleService: ExampleService, 
    private router: Router
  ) {}

  saveExample(): void {
    this.exampleService.createExample(this.example).subscribe(() => {
      this.router.navigate(['/all']);
    });
  }
}