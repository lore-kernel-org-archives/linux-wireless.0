Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f205.google.com ([209.85.217.205]:59109 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455AbZHMUbi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 16:31:38 -0400
Received: by gxk1 with SMTP id 1so1407356gxk.17
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 13:31:38 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 13 Aug 2009 13:31:18 -0700
Message-ID: <43e72e890908131331q371320a3gf1ab53ea27574549@mail.gmail.com>
Subject: Spare warnings - wireless drivers
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

b43:

  CHECK   drivers/net/wireless/b43/phy_g.c
drivers/net/wireless/b43/phy_g.c:974:56: warning: cast truncates bits
from constant value (ffff7fff becomes 7fff)

...

  CHECK   drivers/net/wireless/b43/wa.c
drivers/net/wireless/b43/wa.c:385:60: warning: cast truncates bits
from constant value (ffff00ff becomes ff)
drivers/net/wireless/b43/wa.c:403:55: warning: cast truncates bits
from constant value (ffff00ff becomes ff)
drivers/net/wireless/b43/wa.c:405:55: warning: cast truncates bits
from constant value (ffff00ff becomes ff)
drivers/net/wireless/b43/wa.c:415:71: warning: cast truncates bits
from constant value (ffff0fff becomes fff)


ip2100:

  CHECK   drivers/net/wireless/ipw2x00/ipw2100.c
include/net/inet_sock.h:208:17: warning: do-while statement is not a
compound statement
drivers/net/wireless/ipw2x00/ipw2100.c:2847:21: warning: symbol 'i'
shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2100.c:2770:16: originally declared here
drivers/net/wireless/ipw2x00/ipw2100.c:7888:22: warning: symbol 'mode'
shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2100.c:188:12: originally declared here
drivers/net/wireless/ipw2x00/ipw2100.c:7952:18: warning: symbol 'mode'
shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2100.c:188:12: originally declared here
drivers/net/wireless/ipw2x00/ipw2100.c:8000:18: warning: symbol 'mode'
shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2100.c:188:12: originally declared here
drivers/net/wireless/ipw2x00/ipw2100.c:8268:27: warning: symbol
'_min1' shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2100.c:8268:27: originally declared here
drivers/net/wireless/ipw2x00/ipw2100.c:8268:27: warning: symbol
'_min1' shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2100.c:8268:27: originally declared here
drivers/net/wireless/ipw2x00/ipw2100.c:8268:27: warning: symbol
'_min2' shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2100.c:8268:27: originally declared here
  CC [M]  drivers/net/wireless/ipw2x00/ipw2100.o
  CHECK   drivers/net/wireless/ipw2x00/ipw2200.c
  CHECK   drivers/net/wireless/ipw2x00/ipw2200.c
drivers/net/wireless/ipw2x00/ipw2200.c:847:13: warning: symbol 'led'
shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2200.c:92:12: originally declared here
drivers/net/wireless/ipw2x00/ipw2200.c:891:13: warning: symbol 'led'
shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2200.c:92:12: originally declared here
drivers/net/wireless/ipw2x00/ipw2200.c:935:13: warning: symbol 'led'
shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2200.c:92:12: originally declared here
drivers/net/wireless/ipw2x00/ipw2200.c:980:13: warning: symbol 'led'
shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2200.c:92:12: originally declared here
drivers/net/wireless/ipw2x00/ipw2200.c:1016:13: warning: symbol 'led'
shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2200.c:92:12: originally declared here
drivers/net/wireless/ipw2x00/ipw2200.c:1051:13: warning: symbol 'led'
shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2200.c:92:12: originally declared here
drivers/net/wireless/ipw2x00/ipw2200.c:1823:13: warning: symbol
'channel' shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2200.c:86:12: originally declared here
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: warning: symbol
'_min1' shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: originally declared here
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: warning: symbol
'_min1' shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: originally declared here
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: warning: symbol
'_min1' shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: originally declared here
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: warning: symbol
'_min1' shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: originally declared here
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: warning: symbol
'_min2' shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: originally declared here
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: warning: symbol
'_min1' shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: originally declared here
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: warning: symbol
'_min1' shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: originally declared here
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: warning: symbol
'_min2' shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: originally declared here
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: warning: symbol
'_min1' shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: originally declared here
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: warning: symbol
'_min2' shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: originally declared here
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: warning: symbol
'_min2' shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: originally declared here
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: warning: symbol
'_min1' shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: originally declared here
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: warning: symbol
'_min1' shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: originally declared here
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: warning: symbol
'_min1' shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: originally declared here
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: warning: symbol
'_min2' shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: originally declared here
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: warning: symbol
'_min1' shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: originally declared here
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: warning: symbol
'_min2' shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: originally declared here
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: warning: symbol
'_min2' shadows an earlier one
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: originally declared here
drivers/net/wireless/ipw2x00/ipw2200.c:4268:19: warning: symbol
'_min1' shadows an earlier one
(goes on and on)

  CC [M]  drivers/net/wireless/ipw2x00/ipw2200.o
  CHECK   drivers/net/wireless/ipw2x00/libipw_module.c
include/net/inet_sock.h:208:17: warning: do-while statement is not a
compound statement
  CC [M]  drivers/net/wireless/ipw2x00/libipw_module.o
  CHECK   drivers/net/wireless/ipw2x00/libipw_tx.c
include/net/inet_sock.h:208:17: warning: do-while statement is not a
compound statement
  CC [M]  drivers/net/wireless/ipw2x00/libipw_tx.o
  CHECK   drivers/net/wireless/ipw2x00/libipw_rx.c
include/net/inet_sock.h:208:17: warning: do-while statement is not a
compound statement
  CC [M]  drivers/net/wireless/ipw2x00/libipw_rx.o
  CHECK   drivers/net/wireless/ipw2x00/libipw_wx.c
  CC [M]  drivers/net/wireless/ipw2x00/libipw_wx.o
  CHECK   drivers/net/wireless/ipw2x00/libipw_geo.c
include/net/inet_sock.h:208:17: warning: do-while statement is not a
compound statement


iwmc3200wifi:

drivers/net/wireless/iwmc3200wifi/cfg80211.c:241:5: warning: symbol
'iwm_cfg80211_get_station' was not declared. Should it be static?
  CC [M]  drivers/net/wireless/iwmc3200wifi/cfg80211.o


libertas:

  CHECK   drivers/net/wireless/libertas/assoc.c
drivers/net/wireless/libertas/assoc.c:48:47: error: bad constant expression

libertas_tf:

  CC [M]  drivers/net/wireless/libertas_tf/main.o
drivers/net/wireless/libertas_tf/main.c: In function ‘lbtf_rx’:
drivers/net/wireless/libertas_tf/main.c:506: warning: ‘stats.antenna’
is used uninitialized in this function
drivers/net/wireless/libertas_tf/main.c:506: warning: ‘stats.mactime’
is used uninitialized in this function

Orinoco:

  CHECK   drivers/net/wireless/orinoco/wext.c
drivers/net/wireless/orinoco/wext.c:1294:9: warning: context imbalance
in 'orinoco_ioctl_setibssport' - unexpected unlock

prism54:

  CHECK   drivers/net/wireless/prism54/isl_ioctl.c
drivers/net/wireless/prism54/isl_ioctl.c:2052:27: warning: incorrect
type in assignment (different address spaces)
drivers/net/wireless/prism54/isl_ioctl.c:2052:27:    expected void
[noderef] <asn:1>*pointer
drivers/net/wireless/prism54/isl_ioctl.c:2052:27:    got char *[assigned] memptr
drivers/net/wireless/prism54/isl_ioctl.c:2071:27: warning: incorrect
type in assignment (different address spaces)
drivers/net/wireless/prism54/isl_ioctl.c:2071:27:    expected void
[noderef] <asn:1>*pointer
drivers/net/wireless/prism54/isl_ioctl.c:2071:27:    got char *[assigned] memptr


drivers/net/wireless/prism54/oid_mgt.c:424:22: warning: symbol '_data'
shadows an earlier one
incude/asm-generic/sections.h:7:13: originally declared here


rtl:

  CHECK   drivers/net/wireless/rtl818x/rtl8180_rtl8225.c
drivers/net/wireless/rtl818x/rtl8180_rtl8225.c:53:33: warning: dubious: x | !y

TI:

  CHECK   drivers/net/wireless/wl12xx/wl1251_boot.c
drivers/net/wireless/wl12xx/wl1251_boot.c:227:22: warning: symbol
'interrupt' shadows an earlier one
/home/mcgrof/wireless-testing/arch/x86/include/asm/hw_irq.h:120:13:
originally declared here

  CHECK   drivers/net/wireless/wl12xx/wl1251_sdio.c
drivers/net/wireless/wl12xx/wl1251_sdio.c:68:6: warning: symbol
'wl1251_sdio_read' was not declared. Should it be static?
drivers/net/wireless/wl12xx/wl1251_sdio.c:80:6: warning: symbol
'wl1251_sdio_write' was not declared. Should it be static?
drivers/net/wireless/wl12xx/wl1251_sdio.c:92:6: warning: symbol
'wl1251_sdio_reset' was not declared. Should it be static?
drivers/net/wireless/wl12xx/wl1251_sdio.c:114:6: warning: symbol
'wl1251_sdio_set_power' was not declared. Should it be static?
drivers/net/wireless/wl12xx/wl1251_sdio.c:118:29: warning: symbol
'wl1251_sdio_ops' was not declared. Should it be static?
drivers/net/wireless/wl12xx/wl1251_sdio.c:126:5: warning: symbol
'wl1251_sdio_probe' was not declared. Should it be static?


strip:

include/net/inet_sock.h:208:17: warning: do-while statement is not a
compound statement
drivers/net/wireless/strip.c:490:23: error: bad constant expression

wl3501_cs:

  CC [M]  drivers/net/wireless/wl3501_cs.o
drivers/net/wireless/wl3501_cs.c: In function ‘wl3501_esbq_exec’:
drivers/net/wireless/wl3501_cs.c:387: warning: ‘tmp’ is used
uninitialized in this function
drivers/net/wireless/wl3501_cs.c:384: note: ‘tmp’ was declared here

mwl8k:

  CHECK   drivers/net/wireless/mwl8k.c
drivers/net/wireless/mwl8k.c:1600:16: warning: incorrect type in
assignment (different address spaces)
drivers/net/wireless/mwl8k.c:1600:16:    expected unsigned short
[noderef] [usertype] <asn:2>*result
drivers/net/wireless/mwl8k.c:1600:16:    got unsigned short *<noident>
drivers/net/wireless/mwl8k.c:1611:23: warning: dereference of noderef expression
drivers/net/wireless/mwl8k.c:1616:33: warning: dereference of noderef expression
