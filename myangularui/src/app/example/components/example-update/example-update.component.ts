import { Component } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { ExampleService } from '../../services/example.service';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';

@Component({
  selector: 'app-example-update',
  standalone: true,
  templateUrl: './example-update.component.html',
  styleUrls: ['./example-update.component.css'],
  imports: [CommonModule, FormsModule, HttpClientModule],
  providers: [ExampleService],
})
export class ExampleUpdateComponent {
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

  updateExample() {
    if (this.example) {
      this.exampleService.updateExample(this.example).subscribe(() => {
        this.router.navigate(['/all']);
      });
    }
  }

  cancel() {
    this.router.navigate(['/all']);
  }
}