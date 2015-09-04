Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:34205 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758754AbbIDNAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Sep 2015 09:00:12 -0400
Received: by ykdg206 with SMTP id g206so19634798ykd.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2015 06:00:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <fb36615adea446698b3c02498b213efe@SC-EXCH04.marvell.com>
References: <CAAfyv36YLsEVarY6J8H-=Vcox=ktgeCUkqurHnAXzj_UFfthYw@mail.gmail.com>
	<26c3f35fd9e74b1d80e80077c19b6717@SC-EXCH04.marvell.com>
	<CAAfyv36Xf4f33wZvKMeTomyr_T-LKKMYkpYQwWt6B83UthFr8Q@mail.gmail.com>
	<CAOiWkA92XpC8jNq1SY_CDzNEbxNL=zrdAGMHQTs=CeLoYjSU4A@mail.gmail.com>
	<fb36615adea446698b3c02498b213efe@SC-EXCH04.marvell.com>
Date: Fri, 4 Sep 2015 09:00:11 -0400
Message-ID: <CAOiWkA-m+iJAGkAAX2owFj=Kh0dMx5F0uYH8S6F+cw5v3Qbu1g@mail.gmail.com> (sfid-20150904_150020_239780_B91CABFA)
Subject: Re: kernel log flooded with GET_CMD_NODE: cmd node not available
From: Marty Faltesek <mfaltesek@google.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Belisko Marek <marek.belisko@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amit,

On Fri, Sep 4, 2015 at 8:10 AM, Amitkumar Karwar <akarwar@marvell.com> wrote:
> Hi Marty,
>
> Could you please enable debug logs using below command and share complete log?
>
> echo "0xffffffff" > /sys/kernel/debug/mwifiex/mlan0/debug_mask
>
> It should contain normal behavior followed by "cmd node not available" errors.
>

Here you go. Let me know if you need more info.

[  208.661000] mwifiex_sdio mmc1:0001:1: info: RX: port=4 rx_len=1608
[  208.662000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_sdio_card_to_host_mp_aggr: not last packet
[  208.662000] mwifiex_sdio mmc1:0001:1: info: current packet aggregation
[  208.662000] mwifiex_sdio mmc1:0001:1: data: mp_rd_bitmap=0x00000e00
[  208.662000] mwifiex_sdio mmc1:0001:1: data: port=9
mp_rd_bitmap=0x00000e00 -> 0x00000c00
[  208.662000] mwifiex_sdio mmc1:0001:1: info: RX: port=9 rx_len=1608
[  208.662000] mwifiex_sdio mmc1:0001:1: info: rx_len = 1792
[  208.662000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_sdio_card_to_host_mp_aggr: not last packet
[  208.662000] mwifiex_sdio mmc1:0001:1: info: current packet aggregation
[  208.662000] mwifiex_sdio mmc1:0001:1: data: mp_rd_bitmap=0x00000c00
[  208.662000] mwifiex_sdio mmc1:0001:1: data: port=10
mp_rd_bitmap=0x00000c00 -> 0x00000800
[  208.662000] mwifiex_sdio mmc1:0001:1: info: RX: port=10 rx_len=1608
[  208.662000] mwifiex_sdio mmc1:0001:1: info: rx_len = 1792
[  208.662000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_sdio_card_to_host_mp_aggr: not last packet
[  208.662000] mwifiex_sdio mmc1:0001:1: info: current packet aggregation
[  208.662000] mwifiex_sdio mmc1:0001:1: data: mp_rd_bitmap=0x00000800
[  208.662000] mwifiex_sdio mmc1:0001:1: data: port=11
mp_rd_bitmap=0x00000800 -> 0x00000000
[  208.662000] mwifiex_sdio mmc1:0001:1: info: RX: port=11 rx_len=1608
[  208.662000] mwifiex_sdio mmc1:0001:1: info: rx_len = 1792
[  208.662000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_sdio_card_to_host_mp_aggr: last packet
[  208.662000] mwifiex_sdio mmc1:0001:1: info: current packet aggregation
[  208.662000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_sdio_card_to_host_mp_aggr: aggregated packet limit reached
[  208.662000] mwifiex_sdio mmc1:0001:1: info: do_rx_aggr: num of packets: 16
[  208.663000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.663000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.663000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.663000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.663000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.663000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.663000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.663000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.663000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.663000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.663000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.663000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.664000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.664000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.664000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.664000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.664000] mwifiex_sdio mmc1:0001:1: data: mp_rd_bitmap=0x00000000
[  208.664000] mwifiex_sdio mmc1:0001:1: info: no more rd_port available
[  208.664000] mwifiex_sdio mmc1:0001:1: EVENT: cause: 0x74
[  208.664000] mwifiex_sdio mmc1:0001:1: event: TX_STATUS Report
[  208.664000] mwifiex_sdio mmc1:0001:1: int: sdio_ireg = 0x41
[  208.664000] mwifiex_sdio mmc1:0001:1: info: rx_len = 256
[  208.664000] mwifiex_sdio mmc1:0001:1: data: 4294875960 BSS(1-0):
Data <= kernel
[  208.664000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Cmd Response ---
[  208.664000] mwifiex_sdio mmc1:0001:1: info: cmd_sent=0 data_sent=0
[  208.664000] mwifiex_sdio mmc1:0001:1: int: UPLD: rd_bitmap=0xffff000
[  208.664000] mwifiex_sdio mmc1:0001:1: data: mp_rd_bitmap=0x0ffff000
[  208.664000] mwifiex_sdio mmc1:0001:1: data: 4294875960 BSS(1-0):
Data <= kernel
[  208.664000] mwifiex_sdio mmc1:0001:1: data: port=12
mp_rd_bitmap=0x0ffff000 -> 0x0fffe000
[  208.664000] mwifiex_sdio mmc1:0001:1: info: RX: port=12 rx_len=37904
[  208.664000] mwifiex_sdio mmc1:0001:1: info: rx_len = 38144
[  208.664000] hostapd-wlan0: Event TX_STATUS (17) received
[  208.664000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_sdio_card_to_host_mp_aggr: not last packet
[  208.665000] mwifiex_sdio mmc1:0001:1: data: 4294875961 BSS(1-0):
Data <= kernel
[  208.665000] mwifiex_sdio mmc1:0001:1: data: 4294875961 BSS(1-0):
Data <= kernel
[  208.665000] mwifiex_sdio mmc1:0001:1: info: current packet aggregation
[  208.665000] mwifiex_sdio mmc1:0001:1: data: mp_rd_bitmap=0x0fffe000
[  208.665000] mwifiex_sdio mmc1:0001:1: data: port=13
mp_rd_bitmap=0x0fffe000 -> 0x0fffc000
[  208.665000] mwifiex_sdio mmc1:0001:1: data: 4294875961 BSS(1-0):
Data <= kernel
[  208.665000] mwifiex_sdio mmc1:0001:1: data: 4294875961 BSS(1-0):
Data <= kernel
[  208.665000] mwifiex_sdio mmc1:0001:1: info: RX: port=13 rx_len=1608
[  208.665000] mwifiex_sdio mmc1:0001:1: info: rx_len = 1792
[  208.665000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_sdio_card_to_host_mp_aggr: not last packet
[  208.665000] mwifiex_sdio mmc1:0001:1: info: current packet aggregation
[  208.665000] mwifiex_sdio mmc1:0001:1: data: 4294875961 BSS(1-0):
Data <= kernel
[  208.665000] mwifiex_sdio mmc1:0001:1: data: mp_rd_bitmap=0x0fffc000
[  208.665000] mwifiex_sdio mmc1:0001:1: data: port=14
mp_rd_bitmap=0x0fffc000 -> 0x0fff8000
[  208.665000] mwifiex_sdio mmc1:0001:1: info: RX: port=14 rx_len=1608
[  208.665000] mwifiex_sdio mmc1:0001:1: info: rx_len = 1792
[  208.665000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_sdio_card_to_host_mp_aggr: not last packet
[  208.665000] mwifiex_sdio mmc1:0001:1: info: current packet aggregation
[  208.665000] mwifiex_sdio mmc1:0001:1: data: 4294875961 BSS(1-0):
Data <= kernel
[  208.665000] mwifiex_sdio mmc1:0001:1: data: mp_rd_bitmap=0x0fff8000
[  208.665000] mwifiex_sdio mmc1:0001:1: data: port=15
mp_rd_bitmap=0x0fff8000 -> 0x0fff0000
[  208.665000] mwifiex_sdio mmc1:0001:1: info: RX: port=15 rx_len=1608
[  208.665000] mwifiex_sdio mmc1:0001:1: info: rx_len = 1792
[  208.666000] mwifiex_sdio mmc1:0001:1: data: 4294875962 BSS(1-0):
Data <= kernel
[  208.666000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_sdio_card_to_host_mp_aggr: not last packet
[  208.666000] mwifiex_sdio mmc1:0001:1: info: current packet aggregation
[  208.666000] mwifiex_sdio mmc1:0001:1: data: mp_rd_bitmap=0x0fff0000
[  208.666000] mwifiex_sdio mmc1:0001:1: data: port=16
mp_rd_bitmap=0x0fff0000 -> 0x0ffe0000
[  208.666000] mwifiex_sdio mmc1:0001:1: info: RX: port=16 rx_len=1608
[  208.666000] mwifiex_sdio mmc1:0001:1: info: rx_len = 1792
[  208.666000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_sdio_card_to_host_mp_aggr: not last packet
[  208.666000] mwifiex_sdio mmc1:0001:1: info: current packet aggregation
[  208.666000] mwifiex_sdio mmc1:0001:1: data: 4294875962 BSS(1-0):
Data <= kernel
[  208.666000] mwifiex_sdio mmc1:0001:1: data: mp_rd_bitmap=0x0ffe0000
[  208.666000] mwifiex_sdio mmc1:0001:1: data: port=17
mp_rd_bitmap=0x0ffe0000 -> 0x0ffc0000
[  208.666000] mwifiex_sdio mmc1:0001:1: info: RX: port=17 rx_len=1608
[  208.666000] mwifiex_sdio mmc1:0001:1: info: rx_len = 1792
[  208.666000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_sdio_card_to_host_mp_aggr: not last packet
[  208.666000] mwifiex_sdio mmc1:0001:1: info: current packet aggregation
[  208.666000] mwifiex_sdio mmc1:0001:1: data: 4294875962 BSS(1-0):
Data <= kernel
[  208.666000] mwifiex_sdio mmc1:0001:1: data: mp_rd_bitmap=0x0ffc0000
[  208.666000] mwifiex_sdio mmc1:0001:1: data: port=18
mp_rd_bitmap=0x0ffc0000 -> 0x0ff80000
[  208.666000] mwifiex_sdio mmc1:0001:1: info: RX: port=18 rx_len=1608
[  208.666000] mwifiex_sdio mmc1:0001:1: info: rx_len = 1792
[  208.666000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_sdio_card_to_host_mp_aggr: not last packet
[  208.666000] mwifiex_sdio mmc1:0001:1: info: current packet aggregation
[  208.666000] mwifiex_sdio mmc1:0001:1: data: mp_rd_bitmap=0x0ff80000
[  208.666000] mwifiex_sdio mmc1:0001:1: data: port=19
mp_rd_bitmap=0x0ff80000 -> 0x0ff00000
[  208.666000] mwifiex_sdio mmc1:0001:1: info: RX: port=19 rx_len=1608
[  208.666000] mwifiex_sdio mmc1:0001:1: info: rx_len = 1792
[  208.666000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_sdio_card_to_host_mp_aggr: not last packet
[  208.666000] mwifiex_sdio mmc1:0001:1: info: current packet aggregation
[  208.666000] mwifiex_sdio mmc1:0001:1: data: mp_rd_bitmap=0x0ff00000
[  208.666000] mwifiex_sdio mmc1:0001:1: data: port=20
mp_rd_bitmap=0x0ff00000 -> 0x0fe00000
[  208.666000] mwifiex_sdio mmc1:0001:1: info: RX: port=20 rx_len=1608
[  208.667000] mwifiex_sdio mmc1:0001:1: info: rx_len = 1792
[  208.667000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_sdio_card_to_host_mp_aggr: not last packet
[  208.667000] mwifiex_sdio mmc1:0001:1: info: current packet aggregation
[  208.667000] mwifiex_sdio mmc1:0001:1: data: mp_rd_bitmap=0x0fe00000
[  208.667000] mwifiex_sdio mmc1:0001:1: data: port=21
mp_rd_bitmap=0x0fe00000 -> 0x0fc00000
[  208.667000] mwifiex_sdio mmc1:0001:1: info: RX: port=21 rx_len=1608
[  208.667000] mwifiex_sdio mmc1:0001:1: info: rx_len = 1792
[  208.667000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_sdio_card_to_host_mp_aggr: not last packet
[  208.667000] mwifiex_sdio mmc1:0001:1: info: current packet aggregation
[  208.667000] mwifiex_sdio mmc1:0001:1: data: mp_rd_bitmap=0x0fc00000
[  208.667000] mwifiex_sdio mmc1:0001:1: data: port=22
mp_rd_bitmap=0x0fc00000 -> 0x0f800000
[  208.667000] mwifiex_sdio mmc1:0001:1: info: RX: port=22 rx_len=1608
[  208.667000] mwifiex_sdio mmc1:0001:1: info: rx_len = 1792
[  208.667000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_sdio_card_to_host_mp_aggr: not last packet
[  208.667000] mwifiex_sdio mmc1:0001:1: info: current packet aggregation
[  208.667000] mwifiex_sdio mmc1:0001:1: data: mp_rd_bitmap=0x0f800000
[  208.667000] mwifiex_sdio mmc1:0001:1: data: port=23
mp_rd_bitmap=0x0f800000 -> 0x0f000000
[  208.667000] mwifiex_sdio mmc1:0001:1: info: RX: port=23 rx_len=1608
[  208.667000] mwifiex_sdio mmc1:0001:1: info: rx_len = 1792
[  208.667000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_sdio_card_to_host_mp_aggr: not last packet
[  208.667000] mwifiex_sdio mmc1:0001:1: info: current packet aggregation
[  208.667000] mwifiex_sdio mmc1:0001:1: data: mp_rd_bitmap=0x0f000000
[  208.667000] mwifiex_sdio mmc1:0001:1: data: port=24
mp_rd_bitmap=0x0f000000 -> 0x0e000000
[  208.667000] mwifiex_sdio mmc1:0001:1: info: RX: port=24 rx_len=1608
[  208.667000] mwifiex_sdio mmc1:0001:1: info: rx_len = 1792
[  208.667000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_sdio_card_to_host_mp_aggr: not last packet
[  208.667000] mwifiex_sdio mmc1:0001:1: info: current packet aggregation
[  208.667000] mwifiex_sdio mmc1:0001:1: data: mp_rd_bitmap=0x0e000000
[  208.667000] mwifiex_sdio mmc1:0001:1: data: port=25
mp_rd_bitmap=0x0e000000 -> 0x0c000000
[  208.667000] mwifiex_sdio mmc1:0001:1: info: RX: port=25 rx_len=1608
[  208.667000] mwifiex_sdio mmc1:0001:1: info: rx_len = 1792
[  208.667000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_sdio_card_to_host_mp_aggr: not last packet
[  208.667000] mwifiex_sdio mmc1:0001:1: info: current packet aggregation
[  208.667000] mwifiex_sdio mmc1:0001:1: data: mp_rd_bitmap=0x0c000000
[  208.667000] mwifiex_sdio mmc1:0001:1: data: port=26
mp_rd_bitmap=0x0c000000 -> 0x08000000
[  208.667000] mwifiex_sdio mmc1:0001:1: info: RX: port=26 rx_len=1608
[  208.668000] mwifiex_sdio mmc1:0001:1: info: rx_len = 1792
[  208.668000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_sdio_card_to_host_mp_aggr: not last packet
[  208.668000] mwifiex_sdio mmc1:0001:1: info: current packet aggregation
[  208.668000] mwifiex_sdio mmc1:0001:1: data: mp_rd_bitmap=0x08000000
[  208.668000] mwifiex_sdio mmc1:0001:1: data: port=27
mp_rd_bitmap=0x08000000 -> 0x00000000
[  208.668000] mwifiex_sdio mmc1:0001:1: info: RX: port=27 rx_len=1608
[  208.668000] mwifiex_sdio mmc1:0001:1: info: rx_len = 1792
[  208.668000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_sdio_card_to_host_mp_aggr: last packet
[  208.668000] mwifiex_sdio mmc1:0001:1: info: current packet aggregation
[  208.668000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_sdio_card_to_host_mp_aggr: aggregated packet limit reached
[  208.668000] mwifiex_sdio mmc1:0001:1: info: do_rx_aggr: num of packets: 16
[  208.669000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Aggr Data packet ---
[  208.669000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.669000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.669000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.670000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.670000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.670000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.670000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.670000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.670000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.670000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.670000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.670000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.670000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.670000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.670000] mwifiex_sdio mmc1:0001:1: info: --- Rx: Data packet ---
[  208.670000] mwifiex_sdio mmc1:0001:1: data: mp_rd_bitmap=0x00000000
[  208.670000] mwifiex_sdio mmc1:0001:1: info: no more rd_port available
[  208.670000] mwifiex_sdio mmc1:0001:1: cmd: CMD_RESP: 0x80ce, result
0, len 24, seqno 0x101d
[  208.670000] mwifiex_sdio mmc1:0001:1: info: BA stream complete
[  208.670000] mwifiex_sdio mmc1:0001:1: cmd: FREE_CMD: cmd=0xce, cmd_pending=49
[  208.670000] mwifiex_sdio mmc1:0001:1: cmd: DNLD_CMD: 0xce, act
0x8000, len 22, seqno 0x101e
[  208.670000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_host_to_card_mp_aggr: tx aggregation disabled
[  208.670000] mwifiex_sdio mmc1:0001:1: data:
mwifiex_host_to_card_mp_aggr: send current buffer 32768
[  208.670000] mwifiex_sdio mmc1:0001:1: data: tid=0
[  208.670000] mwifiex_sdio mmc1:0001:1: cmd: mwifiex_send_addba: tid 0
[  208.670000] mwifiex_sdio mmc1:0001:1: cmd: QUEUE_CMD: cmd=0xce,
cmd_pending=50
[  208.671000] mwifiex_sdio mmc1:0001:1: data: 4294875967 BSS(1-0):
Data <= kernel
[  208.671000] mwifiex_sdio mmc1:0001:1: data: WMM: Pkt Delay: 0 ms, 0
ms sent to FW
[  208.671000] mwifiex_sdio mmc1:0001:1: data: mp_wr_bitmap=0xffffff80
[  208.671000] mwifiex_sdio mmc1:0001:1: data: port=7
mp_wr_bitmap=0xffffff80 -> 0xffffff00
[  208.671000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_host_to_card_mp_aggr: Last packet in Tx Queue.
[  208.671000] mwifiex_sdio mmc1:0001:1: data:
mwifiex_host_to_card_mp_aggr: send current buffer 7
[  208.671000] mwifiex_sdio mmc1:0001:1: data: 4294875967 BSS(1-0):
Data <= kernel
[  208.671000] mwifiex_sdio mmc1:0001:1: data: tid=0
[  208.671000] mwifiex_sdio mmc1:0001:1: cmd: mwifiex_send_addba: tid 0
[  208.671000] mwifiex_sdio mmc1:0001:1: GET_CMD_NODE: cmd node not available
[  208.671000] mwifiex_sdio mmc1:0001:1: PREP_CMD: no free cmd node
[  208.671000] mwifiex_sdio mmc1:0001:1: data: dequeuing the packet
cc704300 cc6ac800
[  208.671000] mwifiex_sdio mmc1:0001:1: data: WMM: Pkt Delay: 0 ms, 0
ms sent to FW
[  208.671000] mwifiex_sdio mmc1:0001:1: data: mp_wr_bitmap=0xffffff00
[  208.671000] mwifiex_sdio mmc1:0001:1: data: port=8
mp_wr_bitmap=0xffffff00 -> 0xfffffe00
[  208.671000] mwifiex_sdio mmc1:0001:1: data: 4294875967 BSS(1-0):
Data <= kernel
[  208.671000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_host_to_card_mp_aggr: Last packet in Tx Queue.
[  208.671000] mwifiex_sdio mmc1:0001:1: data:
mwifiex_host_to_card_mp_aggr: send current buffer 8
[  208.671000] mwifiex_sdio mmc1:0001:1: data: tid=0
[  208.671000] mwifiex_sdio mmc1:0001:1: cmd: mwifiex_send_addba: tid 0
[  208.671000] mwifiex_sdio mmc1:0001:1: GET_CMD_NODE: cmd node not available
[  208.671000] mwifiex_sdio mmc1:0001:1: PREP_CMD: no free cmd node
[  208.671000] mwifiex_sdio mmc1:0001:1: data: dequeuing the packet
cc704300 cc6acd00
[  208.671000] mwifiex_sdio mmc1:0001:1: data: 4294875967 BSS(1-0):
Data <= kernel
[  208.671000] mwifiex_sdio mmc1:0001:1: data: 4294875967 BSS(1-0):
Data <= kernel
[  208.672000] mwifiex_sdio mmc1:0001:1: data: 4294875968 BSS(1-0):
Data <= kernel
[  208.672000] mwifiex_sdio mmc1:0001:1: data: WMM: Pkt Delay: 0 ms, 0
ms sent to FW
[  208.672000] mwifiex_sdio mmc1:0001:1: data: mp_wr_bitmap=0xfffffe00
[  208.672000] mwifiex_sdio mmc1:0001:1: data: port=9
mp_wr_bitmap=0xfffffe00 -> 0xfffffc00
[  208.672000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_host_to_card_mp_aggr: Last packet in Tx Queue.
[  208.672000] mwifiex_sdio mmc1:0001:1: data: 4294875968 BSS(1-0):
Data <= kernel
[  208.672000] mwifiex_sdio mmc1:0001:1: data:
mwifiex_host_to_card_mp_aggr: send current buffer 9
[  208.672000] mwifiex_sdio mmc1:0001:1: data: tid=0
[  208.672000] mwifiex_sdio mmc1:0001:1: cmd: mwifiex_send_addba: tid 0
[  208.672000] mwifiex_sdio mmc1:0001:1: GET_CMD_NODE: cmd node not available
[  208.672000] mwifiex_sdio mmc1:0001:1: PREP_CMD: no free cmd node
[  208.672000] mwifiex_sdio mmc1:0001:1: data: 4294875968 BSS(1-0):
Data <= kernel
[  208.672000] mwifiex_sdio mmc1:0001:1: data: WMM: Pkt Delay: 0 ms, 0
ms sent to FW
[  208.672000] mwifiex_sdio mmc1:0001:1: data: 4294875968 BSS(1-0):
Data <= kernel
[  208.672000] mwifiex_sdio mmc1:0001:1: data: mp_wr_bitmap=0xfffffc00
[  208.672000] mwifiex_sdio mmc1:0001:1: data: port=10
mp_wr_bitmap=0xfffffc00 -> 0xfffff800
[  208.672000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_host_to_card_mp_aggr: Last packet in Tx Queue.
[  208.672000] mwifiex_sdio mmc1:0001:1: data:
mwifiex_host_to_card_mp_aggr: send current buffer 10
[  208.673000] mwifiex_sdio mmc1:0001:1: data: 4294875969 BSS(1-0):
Data <= kernel
[  208.673000] mwifiex_sdio mmc1:0001:1: data: 4294875969 BSS(1-0):
Data <= kernel
[  208.673000] mwifiex_sdio mmc1:0001:1: data: tid=0
[  208.673000] mwifiex_sdio mmc1:0001:1: data: 4294875969 BSS(1-0):
Data <= kernel
[  208.673000] mwifiex_sdio mmc1:0001:1: cmd: mwifiex_send_addba: tid 0
[  208.673000] mwifiex_sdio mmc1:0001:1: GET_CMD_NODE: cmd node not available
[  208.673000] mwifiex_sdio mmc1:0001:1: PREP_CMD: no free cmd node
[  208.673000] mwifiex_sdio mmc1:0001:1: data: WMM: Pkt Delay: 0 ms, 0
ms sent to FW
[  208.673000] mwifiex_sdio mmc1:0001:1: data: 4294875969 BSS(1-0):
Data <= kernel
[  208.673000] mwifiex_sdio mmc1:0001:1: data: mp_wr_bitmap=0xfffff800
[  208.673000] mwifiex_sdio mmc1:0001:1: data: port=11
mp_wr_bitmap=0xfffff800 -> 0xfffff000
[  208.673000] mwifiex_sdio mmc1:0001:1: info:
mwifiex_host_to_card_mp_aggr: Last packet in Tx Queue.
[  208.673000] mwifiex_sdio mmc1:0001:1: data:
mwifiex_host_to_card_mp_aggr: send current buffer 11
[  208.673000] mwifiex_sdio mmc1:0001:1: data: 4294875969 BSS(1-0):
Data <= kernel
[  208.673000] mwifiex_sdio mmc1:0001:1: data: tid=0
[  208.673000] mwifiex_sdio mmc1:0001:1: cmd: mwifiex_send_addba: tid 0
