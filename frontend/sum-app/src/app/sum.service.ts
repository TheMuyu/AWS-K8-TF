import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class SumService {

  private apiUrl = '/api/sum';

  constructor(private http: HttpClient) {}

  getSum(num1: number, num2: number): Observable<number> {
    return this.http.post<number>(this.apiUrl, { num1, num2 });
  }
}
