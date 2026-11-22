# RTLPlayground 板级支持：SW-106T-A_XM

小米 SW-106T-A 交换机（RTL8372N，4 x 2.5G RJ45 + 2 x SFP+，32 Mbit SPI Flash）
的板级定义和验证固件。

## 状态

| 项目 | 值 |
|---|---|
| 板号 | `SW-106T-A_XM` |
| PCB 号 | `SW-106T-A_XM` |
| 主控 | RTL8372N |
| 端口 | 4 x 2.5G RJ45 + 2 x SFP+ |
| Flash | 32 Mbit SPI，DIO |
| 最终固件 | `V0.2.6` |
| 网络基线 | `V0.1.2_NOLED` |
| 镜像 | 512 KB，不做 4 MB padding |

## 两个节点

### V0.1.2_NOLED：网络基线

- REF 铜口映射：物理 1-4 -> 逻辑 4-7
- 物理 1/2 的 MDI 反序 `0xa90 = 0x03`
- SFP5 / SFP6 引脚映射
- DIO Flash
- Web、VLAN、管理访问、配置保存
- 默认 `192.168.10.247/24`

### V0.2.6：LED 修复

- `LED_PORT_SET_SEL = 0x00030ac0`
- 基于 pad 表重排 `led_mux`
- `LED_GLB_IO_EN = 0xffffffff`
- `LED_GLB_ACTIVE = 0x3fffffff`
- 无 link 全灭

## LED 行为

| 状态 | LED |
|---|---|
| 无 link | 全灭 |
| 1 口 | 1 绿闪 |
| 2 口 | 2 绿闪 |
| 3 口 | 3 绿闪 |
| 4 口 | 4 橙闪 |
| SFP5 | 5 蓝闪 |
| SFP6 | 6 蓝闪 |

本机 4 口是橙灯，这是实测行为，不是故障。

## 端口与引脚

| 功能 | 映射 |
|---|---|
| 物理 1-4 | 逻辑 4-7 |
| SFP5 | 逻辑 8 / SDS1 / GPIO38 / I2C 39/40 |
| SFP6 | 逻辑 3 / SDS0 / GPIO37 / I2C 41/40 |
| MDI 反序 | `0xa90 = 0x03` |
| Flash | DIO，`flash_sio = 0` |

## 目录

```text
machine/                 板级定义
config/default.txt       默认 VLAN1 / 192.168.10.247
config/configured4000.txt
docs/boards/             板号和引脚
docs/iterations/         V0.1.2 / V0.2.6 记录
docs/validation/         网络和 LED 验证
firmware/                512 KB 镜像
ci/                      GitHub Actions 文件
```

## 构建

```sh
make MACHINE=SW-106T-A_XM \
     CONFIG=config/default.txt \
     VERSION=0.2.6
```

输出是 512 KB 镜像，不要 padding 成 4 MB。

## 刷写

默认配置：

```text
IP:      192.168.10.247
Netmask: 255.255.255.0
Gateway: 192.168.10.1
用户名: admin
密码:   admin
```

Web 固件升级会保留配置区。刷 configured 镜像后需要执行
`factory-reset`、恢复默认，或用编程器整片写。

## 验证

- [网络结果](docs/validation/network-test-results.md)
- [LED 结果](docs/validation/led-test-results.md)
- [LED pad 表](docs/validation/led-pad-map.csv)

## CI

workflow 源文件在 `ci/build-sw106.yml`。如果 GitHub 上还没有启用，
把它复制到 `.github/workflows/build-sw106.yml` 一次即可。它会构建镜像、
校验 524288 字节并上传 artifact。

## 英文

[README.md](README.md)

## 致谢

RTLPlayground 上游、SDCC 及 RTL837x 社区。
