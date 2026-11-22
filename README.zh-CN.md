# RTLPlayground 鏉跨骇鏀寔锛歋W-106T-A_XM

灏忕背 SW-106T-A锛圧TL8372N锛? 脳 2.5G RJ45 + 2 脳 SFP+锛?2 Mbit SPI Flash锛夌殑
鏉跨骇瀹氫箟銆佷袱杞凯浠ｈ褰曞拰楠岃瘉璧勬枡锛岀敤浜庢彁浜ゅ埌 RTLPlayground 涓婃父銆?
## 鐘舵€?
| 椤圭洰 | 鍊?|
|---|---|
| 鏉垮彿 | `SW-106T-A_XM` |
| PCB 鍙?| `SW-106T-A_XM` |
| 涓绘帶 | RTL8372N |
| 绔彛 | 4 脳 2.5G RJ45 + 2 脳 SFP+ |
| Flash | 32 Mbit SPI锛孌IO |
| 鏈€缁堝浐浠?| `V0.2.6` |
| 缃戠粶鍩虹嚎 | `V0.1.2_NOLED` |
| 闀滃儚澶у皬 | 512 KB锛屼笉鍋?4 MB padding |

## 涓や釜鍏抽敭鑺傜偣

### 1. 缃戠粶鍩虹嚎锛歏0.1.2_NOLED

绗竴鐗堝彲鐢ㄥ浐浠讹紝瀹屾垚浜嗭細

- REF 閾滃彛鏄犲皠锛氱墿鐞?1鈥? 鈫?閫昏緫 4鈥?锛?- 鐗╃悊 1/2 鐨?MDI 鍙嶅簭 `0xa90 = 0x03`锛?- SFP5 / SFP6 寮曡剼鏄犲皠锛?- DIO Flash 妯″紡锛?- Web銆乂LAN銆佺鐞嗚闂€侀厤缃繚瀛橈紱
- 榛樿閰嶇疆 `192.168.10.247/24`銆?
璇︾粏璁板綍锛歔docs/iterations/V0.1.2-network-baseline.md](docs/iterations/V0.1.2-network-baseline.md)

### 2. LED 淇锛歏0.2.6

鏈€缁堢増鏈紝瀹屾垚浜嗭細

- `leds_setup()` 蹇呴』鐪熸鎵ц锛?- `LED_PORT_SET_SEL = 0x00030ac0`锛?- 鍩轰簬 pad 琛ㄩ噸鎺?`led_mux`锛?- `LED_GLB_IO_EN = 0xffffffff`锛?- `LED_GLB_ACTIVE = 0x3fffffff`锛?- 鏃?link 鍏ㄧ伃锛?- 1/2/3/4 鍜?SFP5/6 涓庣鍙ｄ竴涓€瀵瑰簲銆?
璇︾粏璁板綍锛歔docs/iterations/V0.2.6-led.md](docs/iterations/V0.2.6-led.md)

## LED 瀹炴祴琛屼负

| 鐘舵€?| LED |
|---|---|
| 鏃?link | 鍏ㄧ伃 |
| 1 鍙?| 1 缁块棯 |
| 2 鍙?| 2 缁块棯 |
| 3 鍙?| 3 缁块棯 |
| 4 鍙?| 4 姗欓棯 |
| SFP5 | 5 钃濋棯 |
| SFP6 | 6 钃濋棯 |

**鏇存锛?* 涔嬪墠鐨勬暣鐞嗘枃妗ｆ妸 4 鍙?LED 棰滆壊褰撴垚寮傚父锛岃繖鏄枃妗ｉ敊璇€? 
鏈満 4 鍙ｅ氨鏄鐏紝琛屼负姝ｇ‘锛涗笉鍚?PCB 鎵规棰滆壊鍙兘涓嶅悓锛岄鑹蹭笉鏄晠闅溿€?
## 绔彛涓庡紩鑴?
| 鍔熻兘 | 鏄犲皠 |
|---|---|
| 鐗╃悊 1鈥? | 閫昏緫 4鈥? |
| SFP5 | 閫昏緫 8 / SDS1 / GPIO38 / I虏C 39/40 |
| SFP6 | 閫昏緫 3 / SDS0 / GPIO37 / I虏C 41/40 |
| MDI 鍙嶅簭 | `0xa90 = 0x03` |
| Flash | DIO锛宍flash_sio = 0` |

鏉跨骇璇存槑锛歔docs/boards/SW-106T-A_XM.md](docs/boards/SW-106T-A_XM.md)

## 鐩綍

```text
machine/                 RTLPlayground 鏉跨骇瀹氫箟
config/default.txt       榛樿 VLAN1 / 192.168.10.247
config/configured4000.txt  VLAN4000 绠＄悊閰嶇疆
docs/boards/             鏉垮彿銆佸紩鑴氥€佹彁浜よ鏄?docs/iterations/         V0.1.2 / V0.2.6 杩唬璁板綍
docs/validation/         缃戠粶鍜?LED 楠岃瘉璧勬枡
firmware/                512 KB 娴嬭瘯闀滃儚
build.sh                 鏋勫缓鑴氭湰
```

## 鏋勫缓

鎶?machine 鏂囦欢澶嶅埗杩?RTLPlayground锛?
```sh
cp machine/SW-106T-A_XM.c machine/SW-106T-A_XM.h \
   machine/SW-106T-A_XM_init.c <rtlplayground>/machine/

make MACHINE=SW-106T-A_XM \
     CONFIG=config/default.txt \
     VERSION=0.2.6
```

鐢熸垚 512 KB 闀滃儚锛屼笉瑕?padding 鎴?4 MB銆?
## 鍒锋満涓庨厤缃?
- 榛樿鍥轰欢閰嶇疆锛歚192.168.10.247/24`锛屾墍鏈夊彛 VLAN1锛?- `config/configured4000.txt` 鏄畾鍒堕厤缃細
  - 1鈥? 鍙ｏ細VLAN1 untagged
  - 4 鍙ｏ細VLAN4000 untagged锛孭VID 4000
  - SFP5/6锛歏LAN4000 tagged
  - 绠＄悊 VLAN 4000锛宍192.168.14.100/24`锛岀綉鍏?`192.168.14.254`

**閲嶈锛?* Web 鍥轰欢鍗囩骇涓嶄細瑕嗙洊 Flash 閰嶇疆鍖恒€? 
鍒峰畬 configured 闀滃儚鍚庤鎵ц锛?
```text
factory-reset
```

鎴栬€呮仮澶嶉粯璁ら厤缃紝鎴栫敤缂栫▼鍣ㄦ暣鐗囧啓 512 KB銆? 
鍚﹀垯浠嶇劧鏄棫 IP/鏃?VLAN銆?
## 楠岃瘉璧勬枡

- [缃戠粶娴嬭瘯缁撴灉](docs/validation/network-test-results.md)
- [LED 娴嬭瘯缁撴灉](docs/validation/led-test-results.md)
- [LED pad 琛?CSV](docs/validation/led-pad-map.csv)

缃戠粶楠岃瘉锛?
- 1鈥? 鍙ｉ兘鑳?link銆乸ing锛?- SFP5/6 鑳借瘑鍒?10G 妯″潡骞?link锛?- Web 姝ｅ父锛?- VLAN4000 绠＄悊锛? 鍙?untagged銆丼FP tagged锛夋甯革紱
- 閲嶅惎鍚庨厤缃笉涓€?
LED 楠岃瘉锛?
- 鏃?link 鍏ㄧ伃锛?- 1鈥? 鍙ｅ搴旂伅鍔ㄤ綔锛?- SFP5/6 钃濈伅锛?- `LED_PORT_SET_SEL = 0x00030ac0`锛?- `LED_GLB_ACTIVE = 0x3fffffff`銆?
## 鎻愪氦鍒?RTLPlayground

澶嶅埗锛?
```text
machine/SW-106T-A_XM.c
machine/SW-106T-A_XM.h
machine/SW-106T-A_XM_init.c
docs/boards/SW-106T-A_XM.md
docs/validation/*
```

鍒?RTLPlayground 瀵瑰簲鐩綍锛屾澘鍙峰拰 PCB 鍙烽兘濉?`SW-106T-A_XM`銆?
瀹屾暣娓呭崟锛歔docs/boards/SW-106T-A_XM.md](docs/boards/SW-106T-A_XM.md)

## 宸茬煡璇存槑

- 4 鍙ｆ鐏槸姝ｇ‘鐨勶紱涔嬪墠鏂囨。鍐欐垚寮傚父锛屽凡鏇存锛?- 1 姗欎笉鏄潖鐨勶紝`ledpad 3` 鑳界偣浜紱
- 鍘熷巶寮€鏈哄叏浜槸 bootloader/鏃╂湡鑷锛屼笉鏄?`LED_MODE` bit17锛?- 10GBASE-T SFP+ 妯″潡鎺?2.5G 瀵圭鏃讹紝Web 鍙兘鏄剧ず 10G锛岃繖鏄富鏈轰晶閫熺巼锛?- 鏈澘鏃犲彲鐢?UART锛屽姟蹇呬繚鐣欏畬鏁?Flash 澶囦唤銆?
## 鑻辨枃鏂囨。

[README.md](README.md)

## 鑷磋阿

RTLPlayground 涓婃父椤圭洰銆丼DCC 鍙?RTL837x 绀惧尯銆?
