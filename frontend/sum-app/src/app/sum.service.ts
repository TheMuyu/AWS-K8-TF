import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { catchError, map, Observable, of } from 'rxjs';
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

  checkApiHealth(): Observable<boolean> {
    return this.http.get(`${this.apiUrl}/health`, { responseType: 'text' }).pipe(
      map(res => res.trim() === 'Backend is healthy'),
      catchError(() => of(false))
    );
  }
}
