Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:35763 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbbIGU7l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 16:59:41 -0400
Received: by obuk4 with SMTP id k4so68837687obu.2
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2015 13:59:40 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, shaofu <shaofu@realtek.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] rtlwifi: rtl818x: Move drivers into new realtek directory
Date: Mon,  7 Sep 2015 15:59:16 -0500
Message-Id: <1441659556-20344-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150907_225947_389963_E78802D6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that a new mac80211-based driver for Realtek devices has been submitted,
it is time to reorganize the directories. Rather than having directories
rtlwifi and rtl818x be in drivers/net/wireless/, they will now be in
drivers/net/wireless/realtek/. This change simplifies the directory
structure, but does not result in any configuration changes that are
visable to the user.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
Kalle,

This patch was generated aginst the pending branch of the wireless-drivers-next
git tree.

Larry
---
 drivers/net/wireless/Kconfig                                      | 6 +++---
 drivers/net/wireless/Makefile                                     | 4 +---
 drivers/net/wireless/realtek/Makefile                             | 8 ++++++++
 drivers/net/wireless/{ => realtek}/rtl818x/Kconfig                | 0
 drivers/net/wireless/{ => realtek}/rtl818x/Makefile               | 0
 drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/Makefile       | 2 +-
 drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/dev.c          | 0
 drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/grf5101.c      | 0
 drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/grf5101.h      | 0
 drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/max2820.c      | 0
 drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/max2820.h      | 0
 drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/rtl8180.h      | 0
 drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/rtl8225.c      | 0
 drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/rtl8225.h      | 0
 drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/rtl8225se.c    | 0
 drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/rtl8225se.h    | 0
 drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/sa2400.c       | 0
 drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/sa2400.h       | 0
 drivers/net/wireless/{ => realtek}/rtl818x/rtl8187/Makefile       | 2 +-
 drivers/net/wireless/{ => realtek}/rtl818x/rtl8187/dev.c          | 0
 drivers/net/wireless/{ => realtek}/rtl818x/rtl8187/leds.c         | 0
 drivers/net/wireless/{ => realtek}/rtl818x/rtl8187/leds.h         | 0
 drivers/net/wireless/{ => realtek}/rtl818x/rtl8187/rfkill.c       | 0
 drivers/net/wireless/{ => realtek}/rtl818x/rtl8187/rfkill.h       | 0
 drivers/net/wireless/{ => realtek}/rtl818x/rtl8187/rtl8187.h      | 0
 drivers/net/wireless/{ => realtek}/rtl818x/rtl8187/rtl8225.c      | 0
 drivers/net/wireless/{ => realtek}/rtl818x/rtl8187/rtl8225.h      | 0
 drivers/net/wireless/{ => realtek}/rtl818x/rtl818x.h              | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/Kconfig                | 1 +
 drivers/net/wireless/{ => realtek}/rtlwifi/Makefile               | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/base.c                 | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/base.h                 | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/btcoexist/Makefile     | 0
 .../net/wireless/{ => realtek}/rtlwifi/btcoexist/halbt_precomp.h  | 0
 .../wireless/{ => realtek}/rtlwifi/btcoexist/halbtc8192e2ant.c    | 0
 .../wireless/{ => realtek}/rtlwifi/btcoexist/halbtc8192e2ant.h    | 0
 .../wireless/{ => realtek}/rtlwifi/btcoexist/halbtc8723b1ant.c    | 0
 .../wireless/{ => realtek}/rtlwifi/btcoexist/halbtc8723b1ant.h    | 0
 .../wireless/{ => realtek}/rtlwifi/btcoexist/halbtc8723b2ant.c    | 0
 .../wireless/{ => realtek}/rtlwifi/btcoexist/halbtc8723b2ant.h    | 0
 .../wireless/{ => realtek}/rtlwifi/btcoexist/halbtc8821a1ant.c    | 0
 .../wireless/{ => realtek}/rtlwifi/btcoexist/halbtc8821a1ant.h    | 0
 .../wireless/{ => realtek}/rtlwifi/btcoexist/halbtc8821a2ant.c    | 0
 .../wireless/{ => realtek}/rtlwifi/btcoexist/halbtc8821a2ant.h    | 0
 .../net/wireless/{ => realtek}/rtlwifi/btcoexist/halbtcoutsrc.c   | 0
 .../net/wireless/{ => realtek}/rtlwifi/btcoexist/halbtcoutsrc.h   | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/btcoexist/rtl_btc.c    | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/btcoexist/rtl_btc.h    | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/cam.c                  | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/cam.h                  | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/core.c                 | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/core.h                 | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/debug.c                | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/debug.h                | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/efuse.c                | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/efuse.h                | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/pci.c                  | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/pci.h                  | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/ps.c                   | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/ps.h                   | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/pwrseqcmd.h            | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rc.c                   | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rc.h                   | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/regd.c                 | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/regd.h                 | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/Makefile     | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/def.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/dm.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/dm.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/fw.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/fw.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/hw.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/hw.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/led.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/led.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/phy.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/phy.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/pwrseq.c     | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/pwrseq.h     | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/reg.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/rf.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/rf.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/sw.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/sw.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/table.c      | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/table.h      | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/trx.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/trx.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192c/Makefile      | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192c/dm_common.c   | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192c/dm_common.h   | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192c/fw_common.c   | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192c/fw_common.h   | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192c/main.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192c/phy_common.c  | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192c/phy_common.h  | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/Makefile     | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/def.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/dm.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/dm.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/hw.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/hw.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/led.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/led.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/phy.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/phy.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/reg.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/rf.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/rf.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/sw.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/sw.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/table.c      | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/table.h      | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/trx.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/trx.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/Makefile     | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/def.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/dm.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/dm.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/hw.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/hw.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/led.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/led.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/mac.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/mac.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/phy.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/phy.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/reg.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/rf.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/rf.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/sw.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/sw.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/table.c      | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/table.h      | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/trx.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/trx.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/Makefile     | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/def.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/dm.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/dm.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/fw.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/fw.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/hw.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/hw.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/led.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/led.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/phy.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/phy.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/reg.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/rf.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/rf.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/sw.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/sw.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/table.c      | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/table.h      | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/trx.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/trx.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/Makefile     | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/def.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/dm.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/dm.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/fw.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/fw.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/hw.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/hw.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/led.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/led.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/phy.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/phy.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/pwrseq.c     | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/pwrseq.h     | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/reg.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/rf.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/rf.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/sw.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/sw.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/table.c      | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/table.h      | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/trx.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/trx.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/Makefile     | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/def.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/dm.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/dm.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/fw.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/fw.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/hw.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/hw.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/led.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/led.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/phy.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/phy.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/reg.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/rf.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/rf.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/sw.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/sw.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/table.c      | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/table.h      | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/trx.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/trx.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/Makefile     | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/btc.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/def.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/dm.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/dm.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/fw.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/fw.h         | 0
 .../net/wireless/{ => realtek}/rtlwifi/rtl8723ae/hal_bt_coexist.c | 0
 .../net/wireless/{ => realtek}/rtlwifi/rtl8723ae/hal_bt_coexist.h | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/hal_btc.c    | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/hal_btc.h    | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/hw.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/hw.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/led.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/led.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/phy.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/phy.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/pwrseq.c     | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/pwrseq.h     | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/reg.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/rf.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/rf.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/sw.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/sw.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/table.c      | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/table.h      | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/trx.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/trx.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/Makefile     | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/def.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/dm.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/dm.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/fw.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/fw.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/hw.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/hw.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/led.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/led.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/phy.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/phy.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/pwrseq.c     | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/pwrseq.h     | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/reg.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/rf.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/rf.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/sw.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/sw.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/table.c      | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/table.h      | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/trx.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/trx.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723com/Makefile    | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723com/dm_common.c | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723com/dm_common.h | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723com/fw_common.c | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723com/fw_common.h | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723com/main.c      | 0
 .../net/wireless/{ => realtek}/rtlwifi/rtl8723com/phy_common.c    | 0
 .../net/wireless/{ => realtek}/rtlwifi/rtl8723com/phy_common.h    | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/Makefile     | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/def.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/dm.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/dm.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/fw.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/fw.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/hw.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/hw.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/led.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/led.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/phy.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/phy.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/pwrseq.c     | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/pwrseq.h     | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/reg.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/rf.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/rf.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/sw.c         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/sw.h         | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/table.c      | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/table.h      | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/trx.c        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/trx.h        | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/stats.c                | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/stats.h                | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/usb.c                  | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/usb.h                  | 0
 drivers/net/wireless/{ => realtek}/rtlwifi/wifi.h                 | 0
 288 files changed, 15 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/Makefile
 rename drivers/net/wireless/{ => realtek}/rtl818x/Kconfig (100%)
 rename drivers/net/wireless/{ => realtek}/rtl818x/Makefile (100%)
 rename drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/Makefile (69%)
 rename drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/dev.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/grf5101.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/grf5101.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/max2820.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/max2820.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/rtl8180.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/rtl8225.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/rtl8225.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/rtl8225se.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/rtl8225se.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/sa2400.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtl818x/rtl8180/sa2400.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtl818x/rtl8187/Makefile (62%)
 rename drivers/net/wireless/{ => realtek}/rtl818x/rtl8187/dev.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtl818x/rtl8187/leds.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtl818x/rtl8187/leds.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtl818x/rtl8187/rfkill.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtl818x/rtl8187/rfkill.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtl818x/rtl8187/rtl8187.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtl818x/rtl8187/rtl8225.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtl818x/rtl8187/rtl8225.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtl818x/rtl818x.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/Kconfig (99%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/Makefile (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/base.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/base.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/btcoexist/Makefile (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/btcoexist/halbt_precomp.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/btcoexist/halbtc8192e2ant.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/btcoexist/halbtc8192e2ant.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/btcoexist/halbtc8723b1ant.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/btcoexist/halbtc8723b1ant.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/btcoexist/halbtc8723b2ant.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/btcoexist/halbtc8723b2ant.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/btcoexist/halbtc8821a1ant.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/btcoexist/halbtc8821a1ant.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/btcoexist/halbtc8821a2ant.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/btcoexist/halbtc8821a2ant.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/btcoexist/halbtcoutsrc.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/btcoexist/halbtcoutsrc.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/btcoexist/rtl_btc.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/btcoexist/rtl_btc.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/cam.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/cam.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/core.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/core.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/debug.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/debug.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/efuse.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/efuse.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/pci.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/pci.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/ps.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/ps.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/pwrseqcmd.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rc.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rc.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/regd.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/regd.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/Makefile (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/def.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/dm.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/dm.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/fw.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/fw.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/hw.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/hw.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/led.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/led.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/phy.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/phy.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/pwrseq.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/pwrseq.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/reg.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/rf.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/rf.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/sw.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/sw.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/table.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/table.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/trx.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8188ee/trx.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192c/Makefile (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192c/dm_common.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192c/dm_common.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192c/fw_common.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192c/fw_common.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192c/main.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192c/phy_common.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192c/phy_common.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/Makefile (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/def.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/dm.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/dm.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/hw.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/hw.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/led.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/led.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/phy.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/phy.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/reg.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/rf.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/rf.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/sw.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/sw.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/table.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/table.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/trx.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ce/trx.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/Makefile (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/def.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/dm.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/dm.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/hw.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/hw.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/led.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/led.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/mac.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/mac.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/phy.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/phy.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/reg.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/rf.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/rf.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/sw.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/sw.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/table.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/table.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/trx.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192cu/trx.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/Makefile (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/def.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/dm.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/dm.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/fw.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/fw.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/hw.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/hw.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/led.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/led.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/phy.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/phy.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/reg.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/rf.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/rf.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/sw.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/sw.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/table.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/table.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/trx.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192de/trx.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/Makefile (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/def.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/dm.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/dm.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/fw.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/fw.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/hw.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/hw.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/led.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/led.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/phy.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/phy.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/pwrseq.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/pwrseq.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/reg.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/rf.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/rf.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/sw.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/sw.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/table.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/table.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/trx.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192ee/trx.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/Makefile (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/def.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/dm.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/dm.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/fw.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/fw.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/hw.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/hw.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/led.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/led.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/phy.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/phy.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/reg.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/rf.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/rf.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/sw.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/sw.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/table.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/table.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/trx.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8192se/trx.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/Makefile (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/btc.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/def.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/dm.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/dm.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/fw.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/fw.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/hal_bt_coexist.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/hal_bt_coexist.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/hal_btc.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/hal_btc.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/hw.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/hw.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/led.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/led.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/phy.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/phy.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/pwrseq.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/pwrseq.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/reg.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/rf.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/rf.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/sw.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/sw.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/table.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/table.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/trx.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723ae/trx.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/Makefile (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/def.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/dm.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/dm.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/fw.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/fw.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/hw.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/hw.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/led.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/led.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/phy.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/phy.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/pwrseq.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/pwrseq.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/reg.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/rf.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/rf.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/sw.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/sw.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/table.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/table.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/trx.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723be/trx.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723com/Makefile (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723com/dm_common.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723com/dm_common.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723com/fw_common.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723com/fw_common.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723com/main.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723com/phy_common.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8723com/phy_common.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/Makefile (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/def.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/dm.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/dm.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/fw.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/fw.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/hw.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/hw.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/led.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/led.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/phy.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/phy.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/pwrseq.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/pwrseq.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/reg.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/rf.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/rf.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/sw.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/sw.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/table.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/table.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/trx.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/rtl8821ae/trx.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/stats.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/stats.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/usb.c (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/usb.h (100%)
 rename drivers/net/wireless/{ => realtek}/rtlwifi/wifi.h (100%)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index b37374d..3c7ac84 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -214,8 +214,6 @@ config USB_NET_RNDIS_WLAN
 
 	  If you choose to build a module, it'll be called rndis_wlan.
 
-source "drivers/net/wireless/rtl818x/Kconfig"
-
 config ADM8211
 	tristate "ADMtek ADM8211 support"
 	depends on MAC80211 && PCI
@@ -243,6 +241,8 @@ config ADM8211
 
 	  Thanks to Infineon-ADMtek for their support of this driver.
 
+source "drivers/net/wireless/realtek/rtl818x/Kconfig"
+
 config RTL8XXXU
 	tristate "RTL8723AU/RTL8188[CR]U/RTL819[12]CU (mac80211) support"
 	depends on MAC80211 && USB
@@ -310,7 +310,7 @@ source "drivers/net/wireless/orinoco/Kconfig"
 source "drivers/net/wireless/p54/Kconfig"
 source "drivers/net/wireless/rt2x00/Kconfig"
 source "drivers/net/wireless/mediatek/Kconfig"
-source "drivers/net/wireless/rtlwifi/Kconfig"
+source "drivers/net/wireless/realtek/rtlwifi/Kconfig"
 source "drivers/net/wireless/ti/Kconfig"
 source "drivers/net/wireless/zd1211rw/Kconfig"
 source "drivers/net/wireless/mwifiex/Kconfig"
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 5ea8df8..92b17cc 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -22,9 +22,7 @@ obj-$(CONFIG_HOSTAP)		+= hostap/
 obj-$(CONFIG_B43)		+= b43/
 obj-$(CONFIG_B43LEGACY)		+= b43legacy/
 obj-$(CONFIG_ZD1211RW)		+= zd1211rw/
-obj-$(CONFIG_RTL8180)		+= rtl818x/
-obj-$(CONFIG_RTL8187)		+= rtl818x/
-obj-$(CONFIG_RTLWIFI)		+= rtlwifi/
+obj-$(CONFIG_WLAN)		+= realtek/
 
 # 16-bit wireless PCMCIA client drivers
 obj-$(CONFIG_PCMCIA_RAYCS)	+= ray_cs.o
diff --git a/drivers/net/wireless/realtek/Makefile b/drivers/net/wireless/realtek/Makefile
new file mode 100644
index 0000000..3489b98
--- /dev/null
+++ b/drivers/net/wireless/realtek/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile for the Linux Wireless network device drivers for Realtek units
+#
+
+obj-$(CONFIG_RTL8180)		+= rtl818x/
+obj-$(CONFIG_RTL8187)		+= rtl818x/
+obj-$(CONFIG_RTLWIFI)		+= rtlwifi/
+
diff --git a/drivers/net/wireless/rtl818x/Kconfig b/drivers/net/wireless/realtek/rtl818x/Kconfig
similarity index 100%
rename from drivers/net/wireless/rtl818x/Kconfig
rename to drivers/net/wireless/realtek/rtl818x/Kconfig
diff --git a/drivers/net/wireless/rtl818x/Makefile b/drivers/net/wireless/realtek/rtl818x/Makefile
similarity index 100%
rename from drivers/net/wireless/rtl818x/Makefile
rename to drivers/net/wireless/realtek/rtl818x/Makefile
diff --git a/drivers/net/wireless/rtl818x/rtl8180/Makefile b/drivers/net/wireless/realtek/rtl818x/rtl8180/Makefile
similarity index 69%
rename from drivers/net/wireless/rtl818x/rtl8180/Makefile
rename to drivers/net/wireless/realtek/rtl818x/rtl8180/Makefile
index 21005bd..2966681 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/Makefile
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/Makefile
@@ -2,4 +2,4 @@ rtl818x_pci-objs	:= dev.o rtl8225.o sa2400.o max2820.o grf5101.o rtl8225se.o
 
 obj-$(CONFIG_RTL8180)	+= rtl818x_pci.o
 
-ccflags-y += -Idrivers/net/wireless/rtl818x
+ccflags-y += -Idrivers/net/wireless/realtek/rtl818x
diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8180/dev.c
rename to drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
diff --git a/drivers/net/wireless/rtl818x/rtl8180/grf5101.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/grf5101.c
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8180/grf5101.c
rename to drivers/net/wireless/realtek/rtl818x/rtl8180/grf5101.c
diff --git a/drivers/net/wireless/rtl818x/rtl8180/grf5101.h b/drivers/net/wireless/realtek/rtl818x/rtl8180/grf5101.h
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8180/grf5101.h
rename to drivers/net/wireless/realtek/rtl818x/rtl8180/grf5101.h
diff --git a/drivers/net/wireless/rtl818x/rtl8180/max2820.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/max2820.c
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8180/max2820.c
rename to drivers/net/wireless/realtek/rtl818x/rtl8180/max2820.c
diff --git a/drivers/net/wireless/rtl818x/rtl8180/max2820.h b/drivers/net/wireless/realtek/rtl818x/rtl8180/max2820.h
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8180/max2820.h
rename to drivers/net/wireless/realtek/rtl818x/rtl8180/max2820.h
diff --git a/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h b/drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8180.h
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
rename to drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8180.h
diff --git a/drivers/net/wireless/rtl818x/rtl8180/rtl8225.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225.c
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8180/rtl8225.c
rename to drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225.c
diff --git a/drivers/net/wireless/rtl818x/rtl8180/rtl8225.h b/drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225.h
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8180/rtl8225.h
rename to drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225.h
diff --git a/drivers/net/wireless/rtl818x/rtl8180/rtl8225se.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225se.c
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8180/rtl8225se.c
rename to drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225se.c
diff --git a/drivers/net/wireless/rtl818x/rtl8180/rtl8225se.h b/drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225se.h
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8180/rtl8225se.h
rename to drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225se.h
diff --git a/drivers/net/wireless/rtl818x/rtl8180/sa2400.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/sa2400.c
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8180/sa2400.c
rename to drivers/net/wireless/realtek/rtl818x/rtl8180/sa2400.c
diff --git a/drivers/net/wireless/rtl818x/rtl8180/sa2400.h b/drivers/net/wireless/realtek/rtl818x/rtl8180/sa2400.h
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8180/sa2400.h
rename to drivers/net/wireless/realtek/rtl818x/rtl8180/sa2400.h
diff --git a/drivers/net/wireless/rtl818x/rtl8187/Makefile b/drivers/net/wireless/realtek/rtl818x/rtl8187/Makefile
similarity index 62%
rename from drivers/net/wireless/rtl818x/rtl8187/Makefile
rename to drivers/net/wireless/realtek/rtl818x/rtl8187/Makefile
index 7b62992..ff07491 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/Makefile
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/Makefile
@@ -2,4 +2,4 @@ rtl8187-objs		:= dev.o rtl8225.o leds.o rfkill.o
 
 obj-$(CONFIG_RTL8187)	+= rtl8187.o
 
-ccflags-y += -Idrivers/net/wireless/rtl818x
+ccflags-y += -Idrivers/net/wireless/realtek/rtl818x
diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8187/dev.c
rename to drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
diff --git a/drivers/net/wireless/rtl818x/rtl8187/leds.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/leds.c
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8187/leds.c
rename to drivers/net/wireless/realtek/rtl818x/rtl8187/leds.c
diff --git a/drivers/net/wireless/rtl818x/rtl8187/leds.h b/drivers/net/wireless/realtek/rtl818x/rtl8187/leds.h
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8187/leds.h
rename to drivers/net/wireless/realtek/rtl818x/rtl8187/leds.h
diff --git a/drivers/net/wireless/rtl818x/rtl8187/rfkill.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/rfkill.c
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8187/rfkill.c
rename to drivers/net/wireless/realtek/rtl818x/rtl8187/rfkill.c
diff --git a/drivers/net/wireless/rtl818x/rtl8187/rfkill.h b/drivers/net/wireless/realtek/rtl818x/rtl8187/rfkill.h
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8187/rfkill.h
rename to drivers/net/wireless/realtek/rtl818x/rtl8187/rfkill.h
diff --git a/drivers/net/wireless/rtl818x/rtl8187/rtl8187.h b/drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8187.h
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8187/rtl8187.h
rename to drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8187.h
diff --git a/drivers/net/wireless/rtl818x/rtl8187/rtl8225.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8187/rtl8225.c
rename to drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c
diff --git a/drivers/net/wireless/rtl818x/rtl8187/rtl8225.h b/drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.h
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl8187/rtl8225.h
rename to drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.h
diff --git a/drivers/net/wireless/rtl818x/rtl818x.h b/drivers/net/wireless/realtek/rtl818x/rtl818x.h
similarity index 100%
rename from drivers/net/wireless/rtl818x/rtl818x.h
rename to drivers/net/wireless/realtek/rtl818x/rtl818x.h
diff --git a/drivers/net/wireless/rtlwifi/Kconfig b/drivers/net/wireless/realtek/rtlwifi/Kconfig
similarity index 99%
rename from drivers/net/wireless/rtlwifi/Kconfig
rename to drivers/net/wireless/realtek/rtlwifi/Kconfig
index 73067ca..f876c7f 100644
--- a/drivers/net/wireless/rtlwifi/Kconfig
+++ b/drivers/net/wireless/realtek/rtlwifi/Kconfig
@@ -152,3 +152,4 @@ config RTLBTCOEXIST
 	default y
 
 endif
+
diff --git a/drivers/net/wireless/rtlwifi/Makefile b/drivers/net/wireless/realtek/rtlwifi/Makefile
similarity index 100%
rename from drivers/net/wireless/rtlwifi/Makefile
rename to drivers/net/wireless/realtek/rtlwifi/Makefile
diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/base.c
rename to drivers/net/wireless/realtek/rtlwifi/base.c
diff --git a/drivers/net/wireless/rtlwifi/base.h b/drivers/net/wireless/realtek/rtlwifi/base.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/base.h
rename to drivers/net/wireless/realtek/rtlwifi/base.h
diff --git a/drivers/net/wireless/rtlwifi/btcoexist/Makefile b/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile
similarity index 100%
rename from drivers/net/wireless/rtlwifi/btcoexist/Makefile
rename to drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile
diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbt_precomp.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/btcoexist/halbt_precomp.h
rename to drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c
rename to drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.h
rename to drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.h
diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b1ant.c
rename to drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b1ant.h
rename to drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c
rename to drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.h
rename to drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/btcoexist/halbtc8821a1ant.c
rename to drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtc8821a1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/btcoexist/halbtc8821a1ant.h
rename to drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/btcoexist/halbtc8821a2ant.c
rename to drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtc8821a2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/btcoexist/halbtc8821a2ant.h
rename to drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c
rename to drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h
rename to drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
diff --git a/drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.c
rename to drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
diff --git a/drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.h
rename to drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
diff --git a/drivers/net/wireless/rtlwifi/cam.c b/drivers/net/wireless/realtek/rtlwifi/cam.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/cam.c
rename to drivers/net/wireless/realtek/rtlwifi/cam.c
diff --git a/drivers/net/wireless/rtlwifi/cam.h b/drivers/net/wireless/realtek/rtlwifi/cam.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/cam.h
rename to drivers/net/wireless/realtek/rtlwifi/cam.h
diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/core.c
rename to drivers/net/wireless/realtek/rtlwifi/core.c
diff --git a/drivers/net/wireless/rtlwifi/core.h b/drivers/net/wireless/realtek/rtlwifi/core.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/core.h
rename to drivers/net/wireless/realtek/rtlwifi/core.h
diff --git a/drivers/net/wireless/rtlwifi/debug.c b/drivers/net/wireless/realtek/rtlwifi/debug.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/debug.c
rename to drivers/net/wireless/realtek/rtlwifi/debug.c
diff --git a/drivers/net/wireless/rtlwifi/debug.h b/drivers/net/wireless/realtek/rtlwifi/debug.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/debug.h
rename to drivers/net/wireless/realtek/rtlwifi/debug.h
diff --git a/drivers/net/wireless/rtlwifi/efuse.c b/drivers/net/wireless/realtek/rtlwifi/efuse.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/efuse.c
rename to drivers/net/wireless/realtek/rtlwifi/efuse.c
diff --git a/drivers/net/wireless/rtlwifi/efuse.h b/drivers/net/wireless/realtek/rtlwifi/efuse.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/efuse.h
rename to drivers/net/wireless/realtek/rtlwifi/efuse.h
diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/pci.c
rename to drivers/net/wireless/realtek/rtlwifi/pci.c
diff --git a/drivers/net/wireless/rtlwifi/pci.h b/drivers/net/wireless/realtek/rtlwifi/pci.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/pci.h
rename to drivers/net/wireless/realtek/rtlwifi/pci.h
diff --git a/drivers/net/wireless/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/ps.c
rename to drivers/net/wireless/realtek/rtlwifi/ps.c
diff --git a/drivers/net/wireless/rtlwifi/ps.h b/drivers/net/wireless/realtek/rtlwifi/ps.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/ps.h
rename to drivers/net/wireless/realtek/rtlwifi/ps.h
diff --git a/drivers/net/wireless/rtlwifi/pwrseqcmd.h b/drivers/net/wireless/realtek/rtlwifi/pwrseqcmd.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/pwrseqcmd.h
rename to drivers/net/wireless/realtek/rtlwifi/pwrseqcmd.h
diff --git a/drivers/net/wireless/rtlwifi/rc.c b/drivers/net/wireless/realtek/rtlwifi/rc.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rc.c
rename to drivers/net/wireless/realtek/rtlwifi/rc.c
diff --git a/drivers/net/wireless/rtlwifi/rc.h b/drivers/net/wireless/realtek/rtlwifi/rc.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rc.h
rename to drivers/net/wireless/realtek/rtlwifi/rc.h
diff --git a/drivers/net/wireless/rtlwifi/regd.c b/drivers/net/wireless/realtek/rtlwifi/regd.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/regd.c
rename to drivers/net/wireless/realtek/rtlwifi/regd.c
diff --git a/drivers/net/wireless/rtlwifi/regd.h b/drivers/net/wireless/realtek/rtlwifi/regd.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/regd.h
rename to drivers/net/wireless/realtek/rtlwifi/regd.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/Makefile b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/Makefile
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8188ee/Makefile
rename to drivers/net/wireless/realtek/rtlwifi/rtl8188ee/Makefile
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/def.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/def.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8188ee/def.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8188ee/def.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8188ee/dm.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/dm.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8188ee/dm.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8188ee/fw.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/fw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8188ee/fw.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8188ee/hw.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/led.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8188ee/led.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8188ee/led.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/led.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/led.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8188ee/led.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8188ee/led.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8188ee/phy.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8188ee/phy.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/reg.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8188ee/reg.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8188ee/reg.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8188ee/rf.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/rf.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8188ee/rf.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8188ee/sw.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/sw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8188ee/sw.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/table.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/table.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8188ee/table.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8188ee/table.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/table.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/table.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8188ee/table.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8188ee/table.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8188ee/trx.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8188ee/trx.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/Makefile b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/Makefile
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192c/Makefile
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192c/Makefile
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/main.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/main.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192c/main.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192c/main.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/Makefile b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/Makefile
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/Makefile
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ce/Makefile
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/def.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/def.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/def.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ce/def.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/dm.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/dm.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ce/dm.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/dm.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/dm.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/dm.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ce/dm.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/hw.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/led.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/led.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ce/led.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/led.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/led.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/led.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ce/led.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/reg.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ce/reg.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/rf.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ce/rf.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rf.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/rf.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/rf.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ce/rf.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/sw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/sw.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/table.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/table.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/table.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ce/table.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/table.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/table.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/table.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ce/table.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/Makefile b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/Makefile
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192cu/Makefile
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192cu/Makefile
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/def.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/def.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192cu/def.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192cu/def.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/dm.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192cu/dm.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192cu/dm.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/dm.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/dm.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192cu/dm.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192cu/dm.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192cu/led.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/led.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192cu/led.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/mac.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192cu/phy.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/reg.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192cu/reg.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192cu/reg.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192cu/rf.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192cu/sw.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/table.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192cu/table.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/table.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192cu/table.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/Makefile b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/Makefile
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192de/Makefile
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192de/Makefile
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/def.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/def.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192de/def.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192de/def.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192de/dm.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/dm.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192de/dm.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192de/fw.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/fw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192de/fw.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192de/hw.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192de/hw.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192de/led.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/led.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192de/led.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192de/phy.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192de/phy.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/reg.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192de/reg.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192de/reg.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/rf.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192de/rf.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192de/rf.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/rf.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/rf.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192de/rf.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192de/rf.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192de/sw.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/sw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192de/sw.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/table.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/table.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192de/table.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192de/table.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/table.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/table.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192de/table.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192de/table.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192de/trx.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192de/trx.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/Makefile b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/Makefile
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ee/Makefile
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ee/Makefile
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/def.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/def.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ee/def.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ee/def.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ee/dm.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/dm.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ee/dm.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ee/dm.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ee/fw.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/fw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ee/fw.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ee/hw.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ee/hw.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/led.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ee/led.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ee/led.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/led.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/led.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ee/led.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ee/led.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ee/phy.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ee/phy.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/pwrseq.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/pwrseq.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ee/pwrseq.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ee/pwrseq.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/pwrseq.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/pwrseq.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ee/pwrseq.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ee/pwrseq.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/reg.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ee/reg.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ee/reg.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/rf.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ee/rf.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ee/rf.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/rf.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/rf.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ee/rf.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ee/rf.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ee/sw.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/sw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ee/sw.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/table.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/table.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ee/table.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ee/table.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/table.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/table.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ee/table.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ee/table.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ee/trx.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ee/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192ee/trx.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/Makefile b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/Makefile
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192se/Makefile
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192se/Makefile
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/def.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/def.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192se/def.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192se/def.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/dm.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192se/dm.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192se/dm.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/dm.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/dm.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192se/dm.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192se/dm.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192se/fw.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/fw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192se/fw.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192se/hw.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192se/hw.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/led.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192se/led.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192se/led.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/led.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/led.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192se/led.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192se/led.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192se/phy.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192se/phy.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/reg.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192se/reg.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192se/reg.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192se/rf.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/rf.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192se/rf.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192se/sw.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/sw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192se/sw.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/table.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/table.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192se/table.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192se/table.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/table.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/table.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192se/table.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192se/table.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192se/trx.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8192se/trx.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/Makefile b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/Makefile
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/Makefile
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/Makefile
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/btc.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/btc.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/btc.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/btc.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/def.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/def.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/def.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/def.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/dm.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/dm.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/dm.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/fw.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/fw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/fw.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/hal_bt_coexist.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/hal_bt_coexist.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/hal_bt_coexist.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/hal_bt_coexist.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/hw.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/led.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/led.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/led.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/phy.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/phy.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/pwrseq.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/pwrseq.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/pwrseq.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/pwrseq.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/pwrseq.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/pwrseq.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/pwrseq.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/pwrseq.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/reg.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/reg.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/reg.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/rf.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/rf.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/rf.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/rf.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/rf.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/rf.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/rf.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/sw.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/sw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/sw.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/table.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/table.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/table.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/table.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723ae/trx.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/Makefile b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/Makefile
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723be/Makefile
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723be/Makefile
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/def.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/def.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723be/def.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723be/def.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723be/dm.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/dm.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723be/dm.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723be/dm.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723be/fw.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/fw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723be/fw.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723be/fw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723be/hw.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723be/hw.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/led.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723be/led.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723be/led.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/led.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/led.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723be/led.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723be/led.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723be/phy.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723be/phy.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/pwrseq.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/pwrseq.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723be/pwrseq.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723be/pwrseq.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/pwrseq.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/pwrseq.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723be/pwrseq.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723be/pwrseq.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/reg.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723be/reg.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723be/reg.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/rf.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723be/rf.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723be/rf.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/rf.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/rf.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723be/rf.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723be/rf.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723be/sw.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/sw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723be/sw.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/table.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/table.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723be/table.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723be/table.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/table.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/table.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723be/table.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723be/table.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723be/trx.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723be/trx.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723com/Makefile b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/Makefile
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723com/Makefile
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723com/Makefile
diff --git a/drivers/net/wireless/rtlwifi/rtl8723com/dm_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/dm_common.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723com/dm_common.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723com/dm_common.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723com/dm_common.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/dm_common.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723com/dm_common.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723com/dm_common.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723com/fw_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723com/fw_common.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723com/fw_common.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723com/fw_common.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723com/fw_common.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8723com/main.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/main.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723com/main.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723com/main.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723com/phy_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/phy_common.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723com/phy_common.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723com/phy_common.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8723com/phy_common.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/phy_common.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8723com/phy_common.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8723com/phy_common.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/Makefile b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/Makefile
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8821ae/Makefile
rename to drivers/net/wireless/realtek/rtlwifi/rtl8821ae/Makefile
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/def.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/def.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8821ae/def.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8821ae/def.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8821ae/dm.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/dm.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8821ae/dm.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8821ae/fw.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/fw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8821ae/fw.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8821ae/fw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8821ae/hw.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/led.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/led.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8821ae/led.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8821ae/led.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/led.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/led.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8821ae/led.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8821ae/led.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8821ae/phy.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8821ae/phy.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/pwrseq.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/pwrseq.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8821ae/pwrseq.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8821ae/pwrseq.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/pwrseq.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/pwrseq.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8821ae/pwrseq.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8821ae/pwrseq.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8821ae/reg.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/rf.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8821ae/rf.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8821ae/rf.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/rf.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/rf.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8821ae/rf.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8821ae/rf.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8821ae/sw.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/sw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8821ae/sw.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/table.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8821ae/table.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/table.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8821ae/table.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.h
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8821ae/trx.c
rename to drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/rtl8821ae/trx.h
rename to drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.h
diff --git a/drivers/net/wireless/rtlwifi/stats.c b/drivers/net/wireless/realtek/rtlwifi/stats.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/stats.c
rename to drivers/net/wireless/realtek/rtlwifi/stats.c
diff --git a/drivers/net/wireless/rtlwifi/stats.h b/drivers/net/wireless/realtek/rtlwifi/stats.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/stats.h
rename to drivers/net/wireless/realtek/rtlwifi/stats.h
diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
similarity index 100%
rename from drivers/net/wireless/rtlwifi/usb.c
rename to drivers/net/wireless/realtek/rtlwifi/usb.c
diff --git a/drivers/net/wireless/rtlwifi/usb.h b/drivers/net/wireless/realtek/rtlwifi/usb.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/usb.h
rename to drivers/net/wireless/realtek/rtlwifi/usb.h
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
similarity index 100%
rename from drivers/net/wireless/rtlwifi/wifi.h
rename to drivers/net/wireless/realtek/rtlwifi/wifi.h
-- 
2.1.4

