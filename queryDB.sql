-- Tambahkan column umur di table mahasiswa
ALTER TABLE mahasiswa
ADD COLUMN umur DATE;

-- Tambahkan data umur di table mahasiswa
UPDATE mahasiswa
SET
    umur = '2002-01-01'
WHERE
    nim = 2024001;

-- Tampilkan Seluruh Data mahasiswa beserta nama jurusannya
SELECT
    mahasiswa.nim,
    mahasiswa.nama,
    mahasiswa.umur,
    jurusan.namajurusan
FROM
    mahasiswa
    JOIN jurusan ON mahasiswa.id_jurusan = jurusan.id;

-- Tampilkan mahasiswa yang memiliki umur dibawah 20 tahun
SELECT
    *
FROM
    mahasiswa
WHERE
    (strftime ('%Y', 'now') - strftime ('%Y', umur)) < 20;

-- Tampilkan mahasiswa yang memiliki nilai 'B' ke atas
SELECT
    mahasiswa.nim,
    mahasiswa.nama,
    matakuliah.nama,
    mahasiswa_matakuliah.nilai
FROM
    mahasiswa
    JOIN mahasiswa_matakuliah ON mahasiswa.nim = mahasiswa_matakuliah.nim_mahasiswa
    JOIN matakuliah ON mahasiswa_matakuliah.id_matakuliah = matakuliah.id
WHERE
    mahasiswa_matakuliah.nilai IN ('A', 'B');

-- Tampilkan mahasiswa yang memiliki sks lebih dari 10
SELECT
    mahasiswa.nim,
    mahasiswa.nama,
    SUM(matakuliah.sks) as total_sks
FROM
    mahasiswa
    JOIN mahasiswa_matakuliah ON mahasiswa.nim = mahasiswa_matakuliah.nim_mahasiswa
    JOIN matakuliah ON mahasiswa_matakuliah.id_matakuliah = matakuliah.id
GROUP BY
    mahasiswa.nim,
    mahasiswa.nama
HAVING
    SUM(matakuliah.sks) > 10;

-- Tampilkan mahasiswa yang mengontrak mata kuliah 'data mining'


SELECT
    mahasiswa.nim,
    mahasiswa.nama,
    matakuliah.nama AS nama_matakuliah
FROM
    mahasiswa
    JOIN mahasiswa_matakuliah ON mahasiswa.nim = mahasiswa_matakuliah.nim_mahasiswa
    JOIN matakuliah ON mahasiswa_matakuliah.id_matakuliah = matakuliah.id
WHERE
    matakuliah.nama LIKE '%data mining%';

-- Tampilkan jumlah mahasiswa untuk setiap dosen
SELECT
    dosen.nama,
    COUNT(DISTINCT mahasiswa_matakuliah.nim_mahasiswa) as jumlah_mahasiswa
FROM
    dosen
    JOIN dosen_matakuliah ON dosen.id = dosen_matakuliah.id_dosen
    JOIN mahasiswa_matakuliah ON dosen_matakuliah.id_matakuliah = mahasiswa_matakuliah.id_matakuliah
GROUP BY
    dosen.id,
    dosen.nama;

-- urutkan mahasiswa berdasarkan umurnya
SELECT
    nim,
    nama,
    (strftime ('%Y', 'now') - strftime ('%Y', umur)) - (
        strftime ('%m-%d', 'now') < strftime ('%m-%d', umur)
    ) as umur
FROM
    mahasiswa
ORDER BY
    umur ASC / DESC;

-- tampilkan kontrak matakuliah yang harus diulangi(nilai D dan E), serta tampilkan data mahasiswa jurusan dan dosen secara lengkap. gunakan mode JOIN dan WHERE clause (solusi terdiri dari 2 sytanx SQL)
-- Query 1: Menggunakan JOIN
SELECT
    m.nim,
    m.nama AS nama_mahasiswa,
    m.alamat,
    m.umur,
    j.namajurusan,
    mk.nama AS nama_matakuliah,
    d.nama AS nama_dosen,
    mm.nilai
FROM
    mahasiswa m
    JOIN jurusan j ON m.id_jurusan = j.id
    JOIN mahasiswa_matakuliah mm ON m.nim = mm.nim_mahasiswa
    JOIN matakuliah mk ON mm.id_matakuliah = mk.id
    JOIN dosen_matakuliah dm ON mk.id = dm.id_matakuliah
    JOIN dosen d ON dm.id_dosen = d.id
WHERE
    mm.nilai IN ('D', 'E');

-- Query 2: Menggunakan WHERE clause
SELECT
    m.nim,
    m.nama AS nama_mahasiswa,
    m.alamat,
    m.umur,
    j.namajurusan,
    mk.nama AS nama_matakuliah,
    d.nama AS nama_dosen,
    mm.nilai
FROM
    mahasiswa m,
    jurusan j,
    mahasiswa_matakuliah mm,
    matakuliah mk,
    dosen_matakuliah dm,
    dosen d
WHERE
    m.id_jurusan = j.id
    AND m.nim = mm.nim_mahasiswa
    AND mm.id_matakuliah = mk.id
    AND mk.id = dm.id_matakuliah
    AND dm.id_dosen = d.id
    AND mm.nilai IN ('D', 'E');