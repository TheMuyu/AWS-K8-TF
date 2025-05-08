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
  currentPage = 0;
  pageSize = 10;
  totalPages = 0;
  loading = false;

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
    this.loading = true;
    this.sumService.getSumList(this.currentPage, this.pageSize).subscribe({
      next: (pageData) => {
        this.sumList = pageData.content;
        this.totalPages = pageData.totalPages;
        this.loading = false;
      },
      error: () => {
        this.loading = false;
      }
    });
  }

  goToPage(page: number): void {
    this.currentPage = page;
    this.loadSumList();
  }

  get pageNumbers(): (number | string)[] {
    const pages: (number | string)[] = [];
    const total = this.totalPages;
    const current = this.currentPage;
  
    if (total <= 7) {
      for (let i = 0; i < total; i++) pages.push(i);
    } else {
      // Always show first page
      pages.push(0);
  
      // Show second page only if current page > 2
      if (current > 2) {
        pages.push('...');
      }
  
      const start = Math.max(1, current - 1);
      const end = Math.min(current + 1, total - 2);
  
      for (let i = start; i <= end; i++) {
        if (i !== 0 && i !== total - 1) pages.push(i);
      }
  
      if (current < total - 3) {
        pages.push('...');
      }
  
      // Always show last page
      pages.push(total - 1);
    }
  
    return pages;
  }
  
  
  asNumber(value: any): number {
    return typeof value === 'number' ? value : this.currentPage;
  }

  displayPageLabel(page: number | string): string {
    return typeof page === 'number' ? (page + 1).toString() : '...';
  }

}
