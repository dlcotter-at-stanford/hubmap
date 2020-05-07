select sample_bk, size_length, size_width, size_depth, x_coord, y_coord, stage, phenotype, organ_piece
from reporting.sample
join reporting.subject on subject.subject_pk = sample.subject_pk
where subject.subject_bk = 'A014' and x_coord is not null and y_coord is not null