# Dockerfile

# 1. Gunakan image Go
FROM golang:1.21-alpine
WORKDIR /app

# 2. Salin file dependensi
COPY go.mod go.sum ./
RUN go mod download

# 3. Salin semua sisa source code
COPY . .

# 4. Jalankan aplikasi Anda
#    Ini adalah entry point dari struktur file Anda
CMD ["go", "run", "cmd/rest/main.go"]