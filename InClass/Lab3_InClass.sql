--Tuan 3--
-------------------------------- QuanLyBanHang --------------------------------------------
USE QuanLyBanHang;
GO

--Bài tập 1: Quản lý bán hàng
--1. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”, mỗi sản 
--phẩm mua với số lượng từ 10 đến 20, và tổng trị giá hóa đơn lớn hơn 500.000.
SELECT HD.SOHD
FROM HOADON HD
JOIN CTHD ON HD.SOHD = CTHD.SOHD
JOIN SANPHAM SP ON CTHD.MASP = SP.MASP
WHERE HD.SOHD IN (
    SELECT SOHD
    FROM CTHD
    WHERE MASP = 'BB01' AND SL BETWEEN 10 AND 20 )
AND HD.SOHD IN (
    SELECT SOHD
    FROM CTHD
    WHERE MASP = 'BB02' AND SL BETWEEN 10 AND 20)
GROUP BY HD.SOHD
HAVING SUM(CTHD.SL * SP.GIA) > 500000;
GO



--2. Tìm các số hóa đơn mua cùng lúc 3 sản phẩm có mã số “BB01”, “BB02” và “BB03”, mỗi sản
--phẩm mua với số lượng từ 10 đến 20, và ngày mua hàng trong năm 2023
SELECT HD.SOHD
FROM HOADON HD
JOIN CTHD ON HD.SOHD = CTHD.SOHD
WHERE CTHD.MASP IN ('BB01', 'BB02', 'BB03')
  AND CTHD.SL BETWEEN 10 AND 20
  AND YEAR(HD.NGHD) = 2023
GROUP BY HD.SOHD
HAVING COUNT(DISTINCT CTHD.MASP) = 3;
GO

--3. Tìm các khách hàng đã mua ít nhất một sản phẩm có mã số “BB01” với số lượng từ 10 đến 20, và
--tổng trị giá tất cả các hóa đơn của họ lớn hơn hoặc bằng 1 triệu đồng.
SELECT KH.MAKH, KH.HOTEN, SUM(HD.TRIGIA) AS TongTriGia
FROM KHACHHANG KH
JOIN HOADON HD ON KH.MAKH = HD.MAKH
WHERE KH.MAKH IN (
    SELECT DISTINCT HD1.MAKH
    FROM HOADON HD1
    JOIN CTHD C1 ON HD1.SOHD = C1.SOHD
    WHERE C1.MASP = 'BB01'
      AND C1.SL BETWEEN 10 AND 20
)
GROUP BY KH.MAKH, KH.HOTEN
HAVING SUM(HD.TRIGIA) >= 1000000;
GO

--4. Tìm các nhân viên bán hàng đã thực hiện giao dịch bán ít nhất một sản phẩm có mã số “BB01”
--hoặc “BB02”, mỗi sản phẩm bán với số lượng từ 15 trở lên, và tổng trị giá của tất cả các hóa đơn mà
--nhân viên đó xử lý lớn hơn hoặc bằng 2 triệu đồng.
SELECT NV.MANV, NV.HOTEN
FROM NHANVIEN NV
JOIN HOADON HD ON NV.MANV = HD.MANV
JOIN CTHD CT ON HD.SOHD = CT.SOHD
WHERE (CT.MASP IN ('BB01', 'BB02') AND CT.SL >= 15)
GROUP BY NV.MANV, NV.HOTEN
HAVING SUM(HD.TRIGIA) >= 2000000;
GO

--5. Tìm các khách hàng đã mua ít nhất hai loại sản phẩm khác nhau với tổng số lượng từ tất cả các hóa
--đơn của họ lớn hơn hoặc bằng 50 và tổng trị giá của họ lớn hơn hoặc bằng 5 triệu đồng.
SELECT KH.MAKH, KH.HOTEN
FROM KHACHHANG KH
JOIN HOADON HD ON KH.MAKH = HD.MAKH
JOIN CTHD CT ON HD.SOHD = CT.SOHD
GROUP BY KH.MAKH, KH.HOTEN, KH.DOANHSO
HAVING COUNT(DISTINCT CT.MASP) >= 2
   AND SUM(CT.SL) >= 50
   AND KH.DOANHSO >= 5000000;
GO

--6. Tìm những khách hàng đã mua cùng lúc ít nhất ba sản phẩm khác nhau trong cùng một hóa đơn và mỗi sản phẩm đều có số lượng từ 5 trở lên.
SELECT DISTINCT KH.MAKH, KH.HOTEN
FROM KHACHHANG KH
JOIN HOADON HD ON KH.MAKH = HD.MAKH
JOIN CTHD CT ON HD.SOHD = CT.SOHD
GROUP BY KH.MAKH, KH.HOTEN, HD.SOHD
HAVING COUNT(DISTINCT CT.MASP) >= 3
   AND MIN(CT.SL) >= 5;
GO

--7. Tìm các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất và đã được bán ra ít nhất 5 lần trong năm 2007
SELECT SP.MASP, SP.TENSP
FROM SANPHAM SP
JOIN CTHD CT ON SP.MASP = CT.MASP
JOIN HOADON HD ON CT.SOHD = HD.SOHD
WHERE SP.NUOCSX = N'Trung Quoc'
  AND YEAR(HD.NGHD) = 2007
GROUP BY SP.MASP, SP.TENSP
HAVING COUNT(CT.SOHD) >= 5;
GO

--8. Tìm các khách hàng đã mua ít nhất một sản phẩm do “Singapore” sản xuất trong năm 2006 và tổng trị giá hóa đơn của họ trong năm đó lớn hơn 1 triệu đồng.
SELECT KH.MAKH, KH.HOTEN
FROM KHACHHANG KH
WHERE KH.MAKH IN (
    SELECT HD.MAKH
    FROM HOADON HD
    JOIN CTHD CT ON HD.SOHD = CT.SOHD
    JOIN SANPHAM SP ON CT.MASP = SP.MASP
    WHERE YEAR(HD.NGHD) = 2006 AND SP.NUOCSX = 'Singapore'
    GROUP BY HD.MAKH )
AND (SELECT SUM(HD.TRIGIA)
    FROM HOADON HD
    WHERE HD.MAKH = KH.MAKH) > 1000000;
GO

--9. Tìm những nhân viên bán hàng đã thực hiện giao dịch bán nhiều nhất các sản phẩm do “Trung Quoc” sản xuất trong năm 2006
WITH DABAN AS (
    SELECT NV.MANV, NV.HOTEN, SUM(CTHD.SL) AS TONGBANHANG
    FROM NHANVIEN NV
    JOIN HOADON HD ON NV.MANV = HD.MANV
    JOIN CTHD ON HD.SOHD = CTHD.SOHD
    JOIN SANPHAM SP ON CTHD.MASP = SP.MASP
    WHERE YEAR(HD.NGHD) = 2006
      AND SP.NUOCSX = N'Trung Quoc'
    GROUP BY NV.MANV, NV.HOTEN
)
SELECT TOP 1 MANV, HOTEN, TONGBANHANG
FROM DABAN
ORDER BY TONGBANHANG DESC;
GO

--10. Tìm những khách hàng chưa từng mua bất kỳ sản phẩm nào do “Singapore” sản xuất nhưng đã mua ít nhất một sản phẩm do “Trung Quoc” sản xuất.
SELECT KH.MAKH, KH.HOTEN
FROM KHACHHANG KH
WHERE KH.MAKH IN (
    SELECT DISTINCT HD.MAKH
    FROM HOADON HD
    JOIN CTHD CT ON HD.SOHD = CT.SOHD
    JOIN SANPHAM SP ON CT.MASP = SP.MASP
    WHERE SP.NUOCSX = 'Trung Quoc'
)
EXCEPT
SELECT DISTINCT HD.MAKH, KH.HOTEN
FROM HOADON HD
JOIN CTHD CT ON HD.SOHD = CT.SOHD
JOIN SANPHAM SP ON CT.MASP = SP.MASP
JOIN KHACHHANG KH ON HD.MAKH = KH.MAKH
WHERE SP.NUOCSX = 'Singapore';
GO

--11. Tìm những hóa đơn có chứa tất cả các sản phẩm do “Singapore” sản xuất và trị giá hóa đơn lớn hơn tổng trị giá trung bình của tất cả các hóa đơn trong hệ thống.
SELECT HD.SOHD
FROM HOADON HD
JOIN CTHD CT ON HD.SOHD = CT.SOHD
JOIN SANPHAM SP ON CT.MASP = SP.MASP
WHERE SP.NUOCSX = 'Singapore'
GROUP BY HD.SOHD, HD.TRIGIA
HAVING COUNT(DISTINCT SP.MASP) = (
    SELECT COUNT(DISTINCT MASP)
    FROM SANPHAM
    WHERE NUOCSX = 'Singapore'
)
AND HD.TRIGIA > (
    SELECT AVG(TRIGIA)
    FROM HOADON
);	
GO

--12. Tìm danh sách các nhân viên có tổng số lượng bán ra của tất cả các loại sản phẩm vượt quá số lượng trung bình của tất cả các nhân viên khác.
SELECT NV.MANV, NV.HOTEN
FROM NHANVIEN NV
JOIN HOADON HD ON NV.MANV = HD.MANV
JOIN CTHD CT ON HD.SOHD = CT.SOHD
GROUP BY NV.MANV, NV.HOTEN
HAVING SUM(CT.SL) > (
    SELECT AVG(TONGTIEN)
    FROM (
        SELECT SUM(CT1.SL) AS TONGTIEN
        FROM NHANVIEN NV1
        JOIN HOADON HD1 ON NV1.MANV = HD1.MANV
        JOIN CTHD CT1 ON HD1.SOHD = CT1.SOHD
        GROUP BY NV1.MANV
    ) AS TRUNGBINH
    WHERE TRUNGBINH.TONGTIEN <> SUM(CT.SL)
);
GO


--13. Tìm danh sách các hóa đơn có chứa ít nhất một sản phẩm từ mỗi nước sản xuất khác nhau có trong hệ thống.
SELECT HD.SOHD
FROM HOADON HD
WHERE NOT EXISTS (
    SELECT NUOCSX
    FROM SANPHAM
    WHERE NOT EXISTS (
        SELECT 1
        FROM CTHD CT
        JOIN SANPHAM SP ON CT.MASP = SP.MASP
        WHERE CT.SOHD = HD.SOHD AND SP.NUOCSX = SANPHAM.NUOCSX
    )
);
GO

----------------------------------- QuanLiHocVu ----------------------------------------------
USE QuanLiHocVu
GO
--1. Tìm danh sách các giáo viên có mức lương cao nhất trong mỗi khoa, kèm theo tên khoa và hệ số lương
SELECT GV.HOTEN, K.TENKHOA, GV.HESO, GV.MUCLUONG
FROM GIAOVIEN GV
JOIN KHOA K ON GV.MAKHOA = K.MAKHOA
WHERE GV.MUCLUONG = (
    SELECT MAX(MUCLUONG)
    FROM GIAOVIEN
    WHERE MAKHOA = GV.MAKHOA
);
GO

--2. Liệt kê danh sách các học viên có điểm trung bình cao nhất trong mỗi lớp, kèm theo tên lớp và mã lớp.
SELECT HV.HO + ' ' + HV.TEN AS HOTEN, L.TENLOP, L.MALOP, HV.DIEMTB
FROM HOCVIEN HV
JOIN LOP L ON HV.MALOP = L.MALOP
WHERE HV.DIEMTB = (
    SELECT MAX(DIEMTB)
    FROM HOCVIEN
    WHERE MALOP = HV.MALOP
);
GO

--3.Tính tổng số tiết lý thuyết (TCLT) và thực hành (TCTH) mà mỗi giáo viên đã giảng dạy trong năm học 2023, sắp xếp theo tổng số tiết từ cao xuống thấp.
SELECT GV.MAGV, GV.HOTEN, SUM(MH.TCLT + MH.TCTH) AS TONGSOTIET
FROM GIANGDAY GD
JOIN MONHOC MH ON GD.MAMH = MH.MAMH
JOIN GIAOVIEN GV ON GD.MAGV = GV.MAGV
WHERE GD.NAM = 2023
GROUP BY GV.MAGV, GV.HOTEN
ORDER BY TONGSOTIET DESC;
GO

--4. Tìm những học viên thi cùng một môn học nhiều hơn 2 lần nhưng chưa bao giờ đạt điểm trên 7, kèm theo mã học viên và mã môn học.
SELECT DISTINCT KQ.MAHV, KQ.MAMH
FROM KETQUATHI KQ
WHERE KQ.MAHV IN (
    SELECT MAHV
    FROM KETQUATHI
    WHERE DIEM <= 7
    GROUP BY MAHV, MAMH
    HAVING COUNT(*) > 2)
AND KQ.MAMH IN (
    SELECT MAMH
    FROM KETQUATHI
    WHERE DIEM <= 7
    GROUP BY MAHV, MAMH
    HAVING COUNT(*) > 2)
AND KQ.MAHV NOT IN (
    SELECT MAHV
    FROM KETQUATHI
    WHERE DIEM > 7);
GO

--5. Xác định những giáo viên đã giảng dạy ít nhất 3 môn học khác nhau trong cùng một năm học, kèm theo năm học và số lượng môn giảng dạy
SELECT MAGV, NAM, SoLuongMonHoc
FROM (
    SELECT 
        MAGV,
        NAM,
        COUNT(DISTINCT MAMH) AS SoLuongMonHoc
    FROM 
        GIANGDAY
    GROUP BY 
        MAGV, NAM
) AS SubQuery
WHERE SoLuongMonHoc >= 3;
GO

--6. Tìm những học viên có sinh nhật trùng với ngày thành lập của khoa mà họ đang theo học, kèm theo tên khoa và ngày sinh của học viên.
SELECT 
    HV.HO, HV.TEN, HV.NGSINH, K.TENKHOA, K.NGTLAP
FROM 
    HOCVIEN HV
JOIN 
    LOP L ON HV.MALOP = L.MALOP
JOIN 
    GIAOVIEN GV ON L.MAGVCN = GV.MAGV
JOIN 
    KHOA K ON GV.MAKHOA = K.MAKHOA
WHERE 
    DAY(HV.NGSINH) = DAY(K.NGTLAP)
    AND MONTH(HV.NGSINH) = MONTH(K.NGTLAP);
GO

--7. Liệt kê các môn học không có điều kiện tiên quyết (không yêu cầu môn học trước), kèm theo mã môn và tên môn học.
SELECT 
    MH.MAMH, MH.TENMH
FROM 
    MONHOC MH
LEFT JOIN 
    DIEUKIEN DK ON MH.MAMH = DK.MAMH
WHERE 
    DK.MAMH_TRUOC IS NULL;
GO

--8. Tìm danh sách các giáo viên dạy nhiều môn học nhất trong học kỳ 1 năm 2006, kèm theo số lượng môn học mà họ đã dạy.
SELECT 
    GD.MAGV, 
    GV.HOTEN, 
    COUNT(GD.MAMH) AS SO_LUONG_MON_HOC
FROM 
    GIANGDAY GD
JOIN 
    GIAOVIEN GV ON GD.MAGV = GV.MAGV
WHERE 
    GD.HOCKY = 1 AND GD.NAM = 2006
GROUP BY 
    GD.MAGV, GV.HOTEN
HAVING 
    COUNT(GD.MAMH) = (
        SELECT MAX(MONHOC_COUNT)
        FROM (
            SELECT COUNT(GD1.MAMH) AS MONHOC_COUNT
            FROM GIANGDAY GD1
            WHERE GD1.HOCKY = 1 AND GD1.NAM = 2006
            GROUP BY GD1.MAGV
        ) AS MONHOC_COUNTS
    );
GO

--9. Tìm những giáo viên đã dạy cả môn “Co So Du Lieu” và “Cau Truc Roi Rac” trong cùng một học kỳ, kèm theo học kỳ và năm học.
SELECT 
    GD.MAGV, 
    GV.HOTEN, 
    GD.HOCKY, 
    GD.NAM
FROM 
    GIANGDAY GD
JOIN 
    GIAOVIEN GV ON GD.MAGV = GV.MAGV
WHERE 
    (GD.MAMH = 'CSDL' OR GD.MAMH = 'CTRRR') 
GROUP BY 
    GD.MAGV, GV.HOTEN, GD.HOCKY, GD.NAM
HAVING 
    COUNT(DISTINCT GD.MAMH) = 2;
GO

--10. Liệt kê danh sách các môn học mà tất cả các giáo viên trong khoa “CNTT” đều đã giảng dạy ít nhất một lần trong năm 2006.
SELECT M.MAMH, M.TENMH
FROM MONHOC M
WHERE NOT EXISTS (
    SELECT 1
    FROM GIAOVIEN GV
    WHERE GV.MAKHOA = 'CNTT'
    AND NOT EXISTS (
        SELECT 1
        FROM GIANGDAY GD
        WHERE GD.MAMH = M.MAMH
        AND GD.MAGV = GV.MAGV
        AND GD.NAM = 2006
    )
)
GO

--11. Tìm những giáo viên có hệ số lương cao hơn mức lương trung bình của tất cả giáo viên trong khoa của họ, kèm theo tên khoa và hệ số lương của giáo viên đó.
SELECT GV.HOTEN, GV.HESO, K.TENKHOA
FROM GIAOVIEN GV
JOIN KHOA K ON GV.MAKHOA = K.MAKHOA
WHERE GV.HESO > (
    SELECT AVG(GV2.HESO)
    FROM GIAOVIEN GV2
    WHERE GV2.MAKHOA = GV.MAKHOA
)
GO

--12. Xác định những lớp có sĩ số lớn hơn 40 nhưng không có giáo viên nào dạy quá 2 môn trong học kỳ 1 năm 2006, kèm theo tên lớp và sĩ số.
SELECT L.TENLOP, L.SISO
FROM LOP L
WHERE L.SISO > 40
AND NOT EXISTS (
    SELECT 1
    FROM GIANGDAY GD
    JOIN GIAOVIEN GV ON GD.MAGV = GV.MAGV
    WHERE GD.HOCKY = 1 AND GD.NAM = 2006
    AND GD.MAGV = L.MAGVCN
    GROUP BY GD.MAGV
    HAVING COUNT(DISTINCT GD.MAMH) > 2
)
GO

--13. Tìm những môn học mà tất cả các học viên của lớp “K11” đều đạt điểm trên 7 trong lần thi cuối cùng của họ, kèm theo mã môn và tên môn học.
SELECT MH.MAMH, MH.TENMH
FROM MONHOC MH
WHERE NOT EXISTS (
    SELECT 1
    FROM HOCVIEN HV
    JOIN KETQUATHI KQ ON HV.MAHV = KQ.MAHV
    WHERE HV.MALOP = 'K11'
    AND KQ.MAMH = MH.MAMH
    AND KQ.LANTHI = (
        SELECT MAX(LANTHI)
        FROM KETQUATHI
        WHERE MAHV = HV.MAHV
    )
    AND KQ.DIEM <= 7
)
GO

--14. Liệt kê danh sách các giáo viên đã dạy ít nhất một môn học trong mỗi học kỳ của năm 2006, kèm theo mã giáo viên và số lượng học kỳ mà họ đã giảng dạy.
SELECT G.MAGV, COUNT(DISTINCT GD.HOCKY) AS SoLuongHocky
FROM GIAOVIEN G
JOIN GIANGDAY GD ON G.MAGV = GD.MAGV
WHERE GD.NAM = 2006
GROUP BY G.MAGV
HAVING COUNT(DISTINCT GD.HOCKY) = 2
GO

--15. Tìm những giáo viên vừa là trưởng khoa vừa giảng dạy ít nhất 2 môn khác nhau trong năm 2006, kèm theo tên khoa và mã giáo viên.
SELECT G.MAGV, K.TENKHOA
FROM GIAOVIEN G
JOIN KHOA K ON G.MAKHOA = K.MAKHOA
JOIN GIANGDAY GD ON G.MAGV = GD.MAGV
WHERE K.TRGKHOA = G.MAGV -- Giáo viên là trưởng khoa
AND GD.NAM = 2006
GROUP BY G.MAGV, K.TENKHOA
HAVING COUNT(DISTINCT GD.MAMH) >= 2; -- Giảng dạy ít nhất 2 môn khác nhau
GO

--16. Xác định những môn học mà tất cả các lớp do giáo viên chủ nhiệm “Nguyen To Lan” đều phải học trong năm 2006, kèm theo mã lớp và tên lớp.
SELECT DISTINCT M.MAMH, M.TENMH
FROM MONHOC M
JOIN GIANGDAY GD ON M.MAMH = GD.MAMH
JOIN LOP L ON GD.MALOP = L.MALOP
JOIN GIAOVIEN GV ON L.MAGVCN = GV.MAGV
WHERE GV.HOTEN = 'Nguyen To Lan'
AND GD.NAM = 2006
AND L.MALOP IN (
    SELECT MALOP
    FROM LOP L
    JOIN GIAOVIEN GV ON L.MAGVCN = GV.MAGV
    WHERE GV.HOTEN = 'Nguyen To Lan'
)
GROUP BY M.MAMH, M.TENMH
HAVING COUNT(DISTINCT L.MALOP) = (
    SELECT COUNT(DISTINCT MALOP)
    FROM LOP L
    JOIN GIAOVIEN GV ON L.MAGVCN = GV.MAGV
    WHERE GV.HOTEN = 'Nguyen To Lan'
); 
GO

--17. Liệt kê danh sách các môn học mà không có điều kiện tiên quyết (không cần phải học trước
--bất kỳ môn nào), nhưng lại là điều kiện tiên quyết cho ít nhất 2 môn khác nhau, kèm theo mã môn và
--tên môn học.
SELECT M.MAMH, M.TENMH
FROM MONHOC M
LEFT JOIN DIEUKIEN D ON M.MAMH = D.MAMH_TRUOC
GROUP BY M.MAMH, M.TENMH
HAVING COUNT(DISTINCT D.MAMH) >= 2
AND NOT EXISTS (
    SELECT 1
    FROM DIEUKIEN D1
    WHERE D1.MAMH = M.MAMH
);
GO

--18. Tìm những học viên (mã học viên, họ tên) thi không đạt môn CSDL ở lần thi thứ 1 nhưng chưa thi lại môn này và cũng chưa thi bất kỳ môn nào khác sau lần đó.
SELECT H.MAHV, H.HO + ' ' + H.TEN AS HOTEN
FROM HOCVIEN H
WHERE H.MAHV IN (
    SELECT KQ.MAHV
    FROM KETQUATHI KQ
    WHERE KQ.MAMH = 'CSDL' AND KQ.LANTHI = 1 AND KQ.DIEM < 5
)
AND H.MAHV NOT IN (
    SELECT KQ.MAHV
    FROM KETQUATHI KQ
    WHERE KQ.MAMH = 'CSDL' AND KQ.LANTHI > 1
)
AND H.MAHV NOT IN (
    SELECT KQ.MAHV
    FROM KETQUATHI KQ
    WHERE KQ.LANTHI > 1
);
GO

--19. Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào trong năm 2006, nhưng đã từng giảng dạy trước đó.
SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV
WHERE GV.MAGV IN (
    SELECT GD.MAGV
    FROM GIANGDAY GD
    WHERE GD.NAM < 2006
)
AND GV.MAGV NOT IN (
    SELECT GD.MAGV
    FROM GIANGDAY GD
    WHERE GD.NAM = 2006
);
GO

--20. Tìm giáo viên (mã giáo viên, họ tên) không được phân công giảng dạy bất kỳ môn học nào
--thuộc khoa giáo viên đó phụ trách trong năm 2006, nhưng đã từng giảng dạy các môn khác của khoa khác.
SELECT GV.MAGV, GV.HOTEN
FROM GIAOVIEN GV
JOIN KHOA K ON GV.MAKHOA = K.MAKHOA
WHERE GV.MAGV IN (
    SELECT GD.MAGV
    FROM GIANGDAY GD
    JOIN MONHOC MH ON GD.MAMH = MH.MAMH
    WHERE GD.NAM = 2006
    AND MH.MAKHOA != GV.MAKHOA -- Môn học không thuộc khoa giáo viên phụ trách
)
AND GV.MAGV NOT IN (
    SELECT GD.MAGV
    FROM GIANGDAY GD
    JOIN MONHOC MH ON GD.MAMH = MH.MAMH
    WHERE GD.NAM = 2006
    AND MH.MAKHOA = GV.MAKHOA -- Giáo viên không giảng dạy môn của khoa họ phụ trách
);
GO

--21. Tìm họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần vẫn "Khong dat", nhưng có điểm trung bình tất cả các môn khác trên 7.
SELECT HV.HO + ' ' + HV.TEN AS HOVATEN
FROM HOCVIEN HV
JOIN LOP L ON HV.MALOP = L.MALOP
WHERE L.TENLOP = 'K11' -- Lọc học viên thuộc lớp "K11"
AND HV.MAHV IN (
    SELECT KQ.MAHV
    FROM KETQUATHI KQ
    WHERE KQ.KQUA = 'Khong dat'
    GROUP BY KQ.MAHV, KQ.MAMH
    HAVING COUNT(KQ.LANTHI) > 3 -- Học viên thi quá 3 lần môn nào đó và kết quả là "Không đạt"
)
AND HV.MAHV IN (
    SELECT KQ.MAHV
    FROM KETQUATHI KQ
    GROUP BY KQ.MAHV
    HAVING AVG(KQ.DIEM) > 7 -- Điểm trung bình tất cả các môn khác trên 7
);
GO

--22. Tìm họ tên các học viên thuộc lớp “K11” thi một môn bất kỳ quá 3 lần vẫn "Khong dat" và thi
--lần thứ 2 của môn CTRR đạt đúng 5 điểm, nhưng điểm trung bình của tất cả các môn khác đều dưới 6
SELECT HV.HO + ' ' + HV.TEN AS HOVATEN
FROM HOCVIEN HV
JOIN LOP L ON HV.MALOP = L.MALOP
WHERE L.TENLOP = 'K11' -- Lọc học viên thuộc lớp "K11"
AND HV.MAHV IN (
    SELECT KQ.MAHV
    FROM KETQUATHI KQ
    WHERE KQ.KQUA = 'Khong dat'
    GROUP BY KQ.MAHV, KQ.MAMH
    HAVING COUNT(KQ.LANTHI) > 3 -- Học viên thi quá 3 lần môn nào đó và kết quả là "Không đạt"
)
AND HV.MAHV IN (
    SELECT KQ.MAHV
    FROM KETQUATHI KQ
    WHERE KQ.MAMH = 'CTRR' AND KQ.LANTHI = 2 -- Thi lần thứ 2 môn "CTRR"
    AND KQ.DIEM = 5 -- Điểm đúng 5
)
AND HV.MAHV IN (
    SELECT KQ.MAHV
    FROM KETQUATHI KQ
    GROUP BY KQ.MAHV
    HAVING AVG(KQ.DIEM) < 6 -- Điểm trung bình các môn khác dưới 6
);

--23. Tìm họ tên giáo viên dạy môn CTRR cho ít nhất hai lớp trong cùng một học kỳ của một năm học và có tổng số tiết giảng dạy (TCLT + TCTH) lớn hơn 30 tiết
SELECT 
    GV.MAGV, 
    COUNT(DISTINCT L.MALOP) AS SoLop, 
    SUM(MH.TCLT + MH.TCTH) AS TongTietGiangDay
FROM 
    GIAOVIEN GV
JOIN 
    GIANGDAY GD ON GV.MAGV = GD.MAGV
JOIN 
    MONHOC MH ON GD.MAMH = MH.MAMH
JOIN 
    LOP L ON GD.MALOP = L.MALOP
WHERE 
    MH.TENMH = N'Cau Truc Roi Rac'
GROUP BY 
    GV.MAGV
HAVING 
    COUNT(DISTINCT L.MALOP) >= 2
    AND SUM(MH.TCLT + MH.TCTH) > 30;
GO
