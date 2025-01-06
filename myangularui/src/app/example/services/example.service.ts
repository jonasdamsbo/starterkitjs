import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Example } from '../models/example.model';

@Injectable({
  providedIn: 'root'
})
export class ExampleService {
  //private apiUrlBase = 'http://localhost:5057/';
  //private apiUrlBase = 'http://localhost:3000/'
  //private apiUrlBase = 'https://jgdtestapiapp.azurewebsites.net/'
  private apiUrlBase = 'http://localhost:8080/'
  private apiUrl = this.apiUrlBase + "api/ExampleModel";

  constructor(private http: HttpClient){}

  getExamples(): Observable<Example[]> {
    console.log("getting all examples!");
    return this.http.get<Example[]>(this.apiUrl);
  }

  getExample(id: string): Observable<Example> {
    console.log("getting example!");
    return this.http.get<Example>(`${this.apiUrl}/${id}`);
  }

  createExample(example: Example): Observable<void> {
    console.log("create example!");
    var res = this.http.post<void>(this.apiUrl, example);
    console.log("after http")
    return res;
  }

  updateExample(example: Example): Observable<Example> {
    console.log("update example!");
    return this.http.put<Example>(`${this.apiUrl}/${example.id}`, example);
  }

  deleteExample(id: string): Observable<void> {
    console.log("delete example!");
    return this.http.delete<void>(`${this.apiUrl}/${id}`);
  }

}