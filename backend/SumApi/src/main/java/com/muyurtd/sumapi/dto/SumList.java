package com.muyurtd.sumapi.dto;

import java.time.LocalDateTime;

public class SumList {
    private int num1;
    private int num2;
    private int sum;
    private LocalDateTime createdDate;

    public SumList(int num1, int num2, int sum, LocalDateTime createdDate) {
        this.num1 = num1;
        this.num2 = num2;
        this.sum = sum;
        this.createdDate = createdDate;
    }

    public int getNum1() { return num1; }
    public int getNum2() { return num2; }
    public int getSum() { return sum; }
    public LocalDateTime getCreatedDate() { return createdDate; }
}
