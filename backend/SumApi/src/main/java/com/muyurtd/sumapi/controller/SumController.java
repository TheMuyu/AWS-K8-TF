package com.muyurtd.sumapi.controller;

import com.muyurtd.sumapi.dto.SumList;
import com.muyurtd.sumapi.dto.SumRequest;
import com.muyurtd.sumapi.model.SumRecord;
import com.muyurtd.sumapi.repository.SumRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;

import java.util.List;


@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*", allowedHeaders = "*")
public class SumController {

    @Autowired
    private SumRepository sumRepository;

    @PostMapping("/sum")
    public ResponseEntity<Integer> calculateSum(@RequestBody SumRequest request) {
        int result = request.getNum1() + request.getNum2();
        SumRecord record = new SumRecord(request.getNum1(), request.getNum2(), result);
        SumRecord savedRecord = sumRepository.save(record);

        if (savedRecord.getId() != null) {
            return ResponseEntity.ok(result);
        } else {
            return ResponseEntity.status(500).build();
        }
    }

    @GetMapping("/list")
    public ResponseEntity<List<SumList>> listSums() {
        List<SumList> responses = sumRepository.findAllByOrderByCreatedDateDesc()
                .stream()
                .map(record -> new SumList(
                        record.getNum1(),
                        record.getNum2(),
                        record.getSum(),
                        record.getCreatedDate()
                ))
                .toList();

        return ResponseEntity.ok(responses);
    }
}
