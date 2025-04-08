import { Component } from '@angular/core';
import { SumService } from '../sum.service';

@Component({
  selector: 'app-sum',
  standalone: false,
  templateUrl: './sum.component.html',
  styleUrl: './sum.component.scss'
})
export class SumComponent {
  
  num1: number = 0;
  num2: number = 0;
  result: number | null = null;

    constructor(private sumService: SumService) {}

  calculateSum() {
    this.sumService.getSum(this.num1, this.num2).subscribe(sum => {
      console.log(sum)
      this.result = sum;
    });
  }
}
