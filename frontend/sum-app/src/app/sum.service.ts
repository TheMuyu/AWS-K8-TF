import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { SumRecord } from './sum-record.model';

@Injectable({
  providedIn: 'root'
})
export class SumService {

  private apiUrl = '/api';
  //private apiUrl = 'http://localhost:8080/api';

  constructor(private http: HttpClient) {}

  getSum(num1: number, num2: number): Observable<number> {
    return this.http.post<number>(`${this.apiUrl}/sum`, { num1, num2 });
  }

  getSumList(): Observable<SumRecord[]> {
    return this.http.get<SumRecord[]>(`${this.apiUrl}/list`);
  }
}
