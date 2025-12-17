program ReservasiBioskop;
uses crt;

const
    MaxFilm     = 10;   // Maksimal jumlah film
    MaxJadwal   = 5;    // Maksimal jadwal per film
    Baris       = 5;    // Jumlah baris kursi studio
    Kolom       = 6;    // Jumlah kolom kursi studio
    Kosong      = 1;    // Status kursi kosong
    Terisi      = 0;    // Status kursi terisi
    MaxTiket    = 100;  // Maksimal tiket yang bisa dipesan

type
    // Tipe data untuk menyimpan informasi film
    TFilm = record
        judul  : string[30];
        genre  : string[20];
        jadwal : array[1..MaxJadwal] of string[10];
        jumlahJadwal : integer;
    end;

    // Tipe data untuk menyimpan informasi tiket
    TTiket = record
        film        : string[30];
        jadwal      : string[10];
        studio      : integer;
        ruangan     : string[10];
        baris_kursi : integer;
        kolom_kursi : integer;
        harga       : longint;
    end;

    // Array 2 dimensi untuk menampilkan status kursi studio
    KursiStudio = array[1..Baris,1..Kolom] of integer;

var
    Film : array[1..MaxFilm] of TFilm;    // Array untuk daftar film
    Kursi: KursiStudio;                   // Status kursi
    Tiket: array[1..MaxTiket] of TTiket;  // Array untuk tiket yang dipesan
    totalFilm, totalTiket: integer;       // Total film dan tiket yang ada

// Prosedur untuk memasukkan data film
procedure InputFilm;
var
    i, j: integer;
begin
    writeln('INPUT FILM');
    write('Berapa film ingin diinput (maks ', MaxFilm, ')? ');
    readln(totalFilm);
    if totalFilm > MaxFilm then totalFilm := MaxFilm;
        for i := 1 to totalFilm do
        begin
            writeln;
            writeln('Film ke-', i);
            write('Judul Film    : '); readln(Film[i].judul);
            write('Genre         : '); readln(Film[i].genre);
            write('Jumlah jadwal (maks ', MaxJadwal, '): ');
            readln(Film[i].jumlahJadwal);
    
            if Film[i].jumlahJadwal > MaxJadwal then
                Film[i].jumlahJadwal := MaxJadwal;
                    for j := 1 to Film[i].jumlahJadwal do
                        begin
                            write('   Jadwal ke-', j, ' : ');
                            readln(Film[i].jadwal[j]);
                        end;
        end;
end;

// Prosedur untuk menampilkan daftar film
procedure TampilFilm;
var
    i, j: integer;
begin
    writeln('DAFTAR FILM');
    writeln;

    if totalFilm = 0 then
        writeln('Belum ada film.')
    else
        for i := 1 to totalFilm do
        begin
            writeln(i, '. ', Film[i].judul);
            writeln('Genre : ', Film[i].genre);
            write('Jadwal: ');
            for j := 1 to Film[i].jumlahJadwal do
                write(Film[i].jadwal[j], '  ');
            writeln;
            writeln;
        end;

    write('Enter untuk kembali...');
    readln;
end;

// Prosedur menampilkan layout kursi studio
procedure TampilkanKursi;
var
    x, y: integer;
begin
    writeln('LAYAR');
    write('     ');
    for x := 1 to Kolom do write(x:3); // Nomor kolom
        writeln;
            for y := 1 to Baris do
            begin
                write('A', y, ' | ');
                for x := 1 to Kolom do
                    if Kursi[y,x] = Kosong then write('O':3)
                    else write('X':3);
                writeln;
            end;
    writeln('O = Kosong , X = Terisi');
end;

// Prosedur untuk memesan tiket
procedure PesanTiket;
var
    pilihFilm, pilihJadwal, ruangan: integer;
    l, c, i, banyakTiket: integer;
    hargaTambahan: longint;
    lagi: char;
begin
    repeat
        if totalFilm = 0 then
        begin
            writeln('Belum ada film!');
            readln;
            exit;
        end;

        // Tampilkan daftar film
        writeln('DAFTAR FILM');
        for i := 1 to totalFilm do
            writeln(i, '. ', Film[i].judul);
            write('Pilih nomor film: ');
            readln(pilihFilm);

        if (pilihFilm < 1) or (pilihFilm > totalFilm) then
            begin
                writeln('Pilihan tidak valid!');
                readln;
                exit;
            end;

        // Tampilkan jadwal
        writeln('DAFTAR JADWAL');
        for i := 1 to Film[pilihFilm].jumlahJadwal do
            writeln(i, '. ', Film[pilihFilm].jadwal[i]);

        write('Pilih jadwal: ');
        readln(pilihJadwal);

        write('Berapa tiket ingin dibeli? ');
        readln(banyakTiket);

        if (banyakTiket < 1) or (totalTiket + banyakTiket > MaxTiket) then
        begin
            writeln('Jumlah tiket melebihi batas!');
            readln;
            exit;
        end;

        for i := 1 to banyakTiket do
        begin
            clrscr;
            writeln('Pilih Kursi Tiket ke-', i);
            TampilkanKursi;

            // Pilih kursi
            repeat
                write('Pilih Baris (1-', Baris, '): ');
                readln(l);

                write('Pilih Kolom (1-', Kolom, '): ');
                readln(c);

                if (l < 1) or (l > Baris) or (c < 1) or (c > Kolom) then
                    writeln('Posisi tidak valid!')
                else if Kursi[l,c] = Terisi then
                    writeln('Kursi sudah diambil!')
                else
                begin
                    Kursi[l,c] := Terisi;
                    break;
                end;
            until false;

            writeln;
            writeln('Pilih tipe ruangan:');
            writeln('1. Biasa   Rp50.000');
            writeln('2. Junior  Rp80.000');
            writeln('3. VIP     Rp100.000');
            write('Pilihan: ');
            readln(ruangan);

            inc(totalTiket);

            Tiket[totalTiket].film        := Film[pilihFilm].judul;
            Tiket[totalTiket].jadwal      := Film[pilihFilm].jadwal[pilihJadwal];
            Tiket[totalTiket].baris_kursi := l;
            Tiket[totalTiket].kolom_kursi := c;

            // Menentukan harga & studio
            case ruangan of
                1:
                    begin
                        hargaTambahan := 50000;
                        Tiket[totalTiket].ruangan := 'Biasa';
                        if random(2) = 0 then
                            Tiket[totalTiket].studio := 1
                        else
                            Tiket[totalTiket].studio := 2;
                    end;

                2:
                    begin
                        hargaTambahan := 80000;
                        Tiket[totalTiket].ruangan := 'Junior';
                        Tiket[totalTiket].studio := 5;
                    end;

                3:
                    begin
                        hargaTambahan := 100000;
                        Tiket[totalTiket].ruangan := 'VIP';
                        if random(2) = 0 then
                            Tiket[totalTiket].studio := 3
                        else
                            Tiket[totalTiket].studio := 4;
                    end;
            end;

            Tiket[totalTiket].harga := hargaTambahan;

            // Cetak sukses
            writeln;
            writeln('TIKET BERHASIL DIPESAN!');
            writeln('Film   : ', Tiket[totalTiket].film);
            writeln('Jadwal : ', Tiket[totalTiket].jadwal);
            writeln('Studio : ', Tiket[totalTiket].studio);
            writeln('Ruangan: ', Tiket[totalTiket].ruangan);
            writeln('Kursi  : Baris A', Tiket[totalTiket].baris_kursi,
                               ' Kolom ', Tiket[totalTiket].kolom_kursi);
            writeln('Harga  : Rp', Tiket[totalTiket].harga);
            readln;
        end;

        write('Pesan tiket lagi? (y/t): ');
        readln(lagi);

    until upcase(lagi) = 'T';
end;

// Cetak semua tiket
procedure CetakSemuaTiket;
var
    i: integer;
    totalHarga: longint;
begin
    totalHarga := 0;

    if totalTiket = 0 then
        writeln('Belum ada tiket dipesan.')
    else
    begin
        for i := 1 to totalTiket do
        begin
            writeln('Tiket ke-', i);
            writeln('Film   : ', Tiket[i].film);
            writeln('Jadwal : ', Tiket[i].jadwal);
            writeln('Studio : ', Tiket[i].studio);
            writeln('Ruangan: ', Tiket[i].ruangan);
            writeln('Kursi  : Baris A', Tiket[i].baris_kursi,
                               ' Kolom ', Tiket[i].kolom_kursi);
            writeln('Harga  : Rp', Tiket[i].harga);
            writeln;

            totalHarga := totalHarga + Tiket[i].harga;
        end;

        writeln('Total Harga Semua Tiket: Rp', totalHarga);
    end;

    readln;
end;

// Program utama
var
    pilih, i, c: integer;

begin
    clrscr;
    randomize;
    totalTiket := 0;

    // Inisialisasi kursi kosong
    for i := 1 to Baris do
        for c := 1 to Kolom do
            Kursi[i,c] := Kosong;

    // Menu utama
    repeat
        writeln('SISTEM RESERVASI BIOSKOP');
        writeln('1. Input Film');
        writeln('2. Tampilkan Film');
        writeln('3. Pesan Tiket');
        writeln('4. Cetak Semua Tiket');
        writeln('5. Keluar');
        write('Pilih menu: ');
        readln(pilih);

        case pilih of
            1: InputFilm;
            2: TampilFilm;
            3: PesanTiket;
            4: CetakSemuaTiket;
            5: writeln('Terima kasih telah menggunakan sistem ini!');
        else
            writeln('Pilihan tidak valid!');
            readln;
        end;
    until pilih = 5;
end.

