package com.muyurtd.sumapi.controller;

import com.muyurtd.sumapi.dto.SumList;
import com.muyurtd.sumapi.dto.SumRequest;
import com.muyurtd.sumapi.model.SumRecord;
import com.muyurtd.sumapi.repository.SumRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;



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
    public ResponseEntity<Page<SumList>> listSums(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {

        Pageable pageable = PageRequest.of(page, size, Sort.by("createdDate").descending());
        Page<SumList> responses = sumRepository.findAllByOrderByCreatedDateDesc(pageable)
                .map(record -> new SumList(
                        record.getNum1(),
                        record.getNum2(),
                        record.getSum(),
                        record.getCreatedDate()
                ));

        return ResponseEntity.ok(responses);
    }
}
