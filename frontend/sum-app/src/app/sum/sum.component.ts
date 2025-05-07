import { Component } from '@angular/core';
import { SumService } from '../sum.service';
import { SumRecord } from '../sum-record.model';
import { version } from '../version';

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
  sumList: SumRecord[] = [];
  version = version;
  apiHealthy: boolean | null = null;

  constructor(private sumService: SumService) { }

  ngOnInit(): void {
    this.sumService.checkApiHealth().subscribe(status => this.apiHealthy = status);
    this.loadSumList();
  }

  calculateSum() {
    this.sumService.getSum(this.num1, this.num2).subscribe(sum => {
      console.log(sum)
      this.result = sum;
      this.loadSumList();
    });
  }

  loadSumList(): void {
    this.sumService.getSumList().subscribe(list => {
      this.sumList = list;
    });
  }

}
