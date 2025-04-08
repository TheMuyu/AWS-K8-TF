package com.muyurtd.sumapi.repository;

import com.muyurtd.sumapi.model.SumRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SumRepository extends JpaRepository<SumRecord, Long> {
}
