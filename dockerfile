FROM golang:1.15-alpine3.12 AS gobuilder-stage


# /app 경로로 이동하고 현재 디렉토리의 app 경로에 모든 파일을 /app에 복사
WORKDIR /usr/src/goapp
COPY main.go .


# Go 언어 환경 변수를 지정하고 /usr/local/bin 경로에 gostart 실행 파일을 생성
# CGO_ENABLED=0 : ego 비활성화. 스크래치(scratch) 이미지에는 C 바이너리가 없기 때문에 ego를 비활성화한 후 빌드
# GOOS=linux GOARCH=amd64 : OS와 아키텍처 설정
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /usr/local/bin/gostart

# 두 번째 단계로 두 번째 Dockerfile을 작성한 것과 같은데 베이스 이미지를 작성합니다.
# 마지막은 컨테이너로 실행되는 단계이므로 일반적으로 단계명을 명시하지 않습니다.
FROM scratch AS runtime-stage

# 첫 번째 단계의 이름을 --from 옵션에 넣으면 해당 단계로부터 파일을 가져와 복사합니다.
COPY --from=gobuilder-stage /usr/local/bin/gostart /usr/local/bin/gostart

# 컨테이너 실행 시 파일을 실행
CMD ["/usr/local/bin/gostart"]

