import { Component, OnInit } from '@angular/core';
import { Example } from '../../models/example.model';
import { ExampleService } from '../../services/example.service';
import { RouterModule } from '@angular/router';
import { CommonModule } from '@angular/common';
import { HttpClientModule } from '@angular/common/http';

@Component({
  selector: 'app-example-list',
  templateUrl: './example-list.component.html',
  styleUrls: ['./example-list.component.css'],
  imports: [RouterModule, CommonModule, HttpClientModule],
  providers: [ExampleService],
})
export class ExampleListComponent implements OnInit {
  examples: Example[] = [];

  constructor(private exampleService: ExampleService) {}

  ngOnInit(): void {
    this.loadExamples();
  }

  loadExamples(): void {
    this.exampleService.getExamples().subscribe(data => this.examples = data);
    console.log(this.examples);
  }
}