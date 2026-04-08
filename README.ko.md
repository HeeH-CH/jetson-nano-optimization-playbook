# Jetson Nano Optimization Playbook

[English](README.md) | [한국어](README.ko.md)

이 저장소는 특정 Jetson Nano 시스템을 위한 재현 가능한 최적화 기록입니다.
적용한 변경은 아래 형태로 남깁니다.

- 코드
- 설치 또는 롤백 절차
- 검증 방법
- 변경 이유

## 현재 시스템

- 보드: NVIDIA Jetson Nano Developer Kit
- JetPack/L4T: R32.7.6
- 커널: `4.9.337-tegra`
- 기록 시점 전원 모드: `MAXN`

## 구조

- `themes/thermal/`: 냉각 및 온도 제어
- `themes/power/`: 전원 모드와 클럭
- `themes/memory/`: swap, zram, 메모리 압박 대응
- `themes/storage/`: SD 카드, SSD, I/O, 정리 작업
- `themes/services/`: systemd, 부팅 정리, 서비스 감사/비활성화
- `themes/deployment/`: 추론 런타임, 컨테이너, 카메라/데이터 파이프라인
- `themes/monitoring/`: 메트릭, 검증, 모니터링
- `tools/`: 점검 및 캡처용 보조 스크립트
- `logs/`: 날짜별 변경 기록

## 작업 원칙

1. 한 번에 한 테마씩 추가하거나 수정합니다.
2. 실제 사용한 파일과 스크립트를 저장합니다.
3. 해당 위치에 짧은 `README.md`를 둡니다.
4. `logs/` 아래에 날짜별 기록을 남깁니다.
5. 범위가 명확한 커밋으로 정리합니다.

## 초기 셋업 메모

- 순정 Jetson Nano OS 이미지에서는 Node.js `16`을 사용합니다. `nvm use 16`
- 더 최신 Node.js 버전은 순정 userspace의 오래된 `glibc` 때문에 설치나 실행이 실패할 수 있습니다.
- 따라서 npm이나 nvm 실패를 바로 애플리케이션 문제로 보면 안 됩니다.

## 현재 반영된 항목

- thermal fan control:
  - 경로: `themes/thermal/fan-control/`
  - 설치: `sudo ./install.sh`
  - 검증: `./status.sh`
  - 롤백: `sudo ./rollback.sh`
- memory zram tuning:
  - 경로: `themes/memory/zram-tuning/`
  - 설치: `sudo ./install.sh`
  - 검증: `./status.sh`
  - 롤백: `sudo ./rollback.sh`
- storage log retention:
  - 경로: `themes/storage/log-retention/`
  - 설치: `sudo ./install.sh`
  - 검증: `./status.sh`
  - 롤백: `sudo ./rollback.sh`
- power performance profile:
  - 경로: `themes/power/performance-profile/`
  - 설치: `sudo ./install.sh`
  - 검증: `./status.sh`
  - 롤백: `sudo ./rollback.sh`
- runtime monitoring:
  - 경로: `themes/monitoring/runtime-health/`
  - 빠른 상태: `./status.sh`
  - 헬스 체크: `./health-check.sh`
  - 라이브 워치: `./live-watch.sh`
  - tegrastats 로그: `./tegrastats-log.sh`
- stress profiling:
  - 경로: `themes/monitoring/stress-profiles/`
  - CPU 부하: `./cpu-burn.sh`
  - 캡처 실행: `./capture-run.sh`
  - 요약: `./summarize-run.sh <run-dir>`
- ONNX/TensorRT 배포 가이드:
  - 경로: `themes/deployment/onnx-tensorrt-guide/`
  - 현재 상태: 문서 전용
  - 나중에 적용: `README.md` 참고

## 스냅샷

빠른 시스템 스냅샷을 찍으려면:

```bash
./tools/collect-system-snapshot.sh
```

## 퍼블리시

`gh` 인증이 정상일 때:

```bash
./tools/publish.sh
```
