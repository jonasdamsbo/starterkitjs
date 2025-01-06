import { Component } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { ExampleService } from '../../services/example.service';
import { CommonModule } from '@angular/common';
import { HttpClientModule } from '@angular/common/http';

@Component({
  selector: 'app-example-delete',
  standalone: true,
  templateUrl: './example-delete.component.html',
  styleUrls: ['./example-delete.component.css'],
  imports: [CommonModule, HttpClientModule],
  providers: [ExampleService],
})
export class ExampleDeleteComponent {
  example: any = null;

  constructor(
    private route: ActivatedRoute,
    private exampleService: ExampleService,
    private router: Router
  ) {
    const exampleId = this.route.snapshot.paramMap.get('id');
    if (exampleId) {
      this.exampleService.getExample(exampleId).subscribe((data) => {
        this.example = data;
      });
    }
  }

  deleteExample() {
    if (this.example) {
      this.exampleService.deleteExample(this.example.id).subscribe(() => {
        this.router.navigate(['/all']);
      });
    }
  }

  cancel() {
    this.router.navigate(['/all']);
  }
}
