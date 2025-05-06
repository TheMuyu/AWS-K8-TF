package com.muyurtd.sumapi.model;

import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "sum_records")
public class SumRecord {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "num1", nullable = false)
    private int num1;

    @Column(name = "num2", nullable = false)
    private int num2;

    @Column(name = "sum", nullable = false)
    private int sum;

    @CreationTimestamp
    @Column(name = "created_date", updatable = false)
    private LocalDateTime createdDate;

    public SumRecord() {

    }

    public SumRecord(int num1, int num2, int sum) {
        this.num1 = num1;
        this.num2 = num2;
        this.sum = sum;
    }

    public Long getId() { return id; }
    public int getNum1() { return num1; }
    public int getNum2() { return num2; }
    public int getSum() { return sum; }
    public LocalDateTime getCreatedDate() { return createdDate; }
}
