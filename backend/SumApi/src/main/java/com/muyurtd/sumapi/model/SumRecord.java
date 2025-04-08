package com.muyurtd.sumapi.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "sum_records")
public class SumRecord {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private int num1;
    private int num2;
    private int sum;
    private LocalDateTime createdDate;

    public SumRecord() {
        this.createdDate = LocalDateTime.now();
    }

    public SumRecord(int num1, int num2, int sum) {
        this.num1 = num1;
        this.num2 = num2;
        this.sum = sum;
        this.createdDate = LocalDateTime.now();
    }

    public Long getId() { return id; }
    public int getNum1() { return num1; }
    public int getNum2() { return num2; }
    public int getSum() { return sum; }
    public LocalDateTime getCreatedDate() { return createdDate; }
}
