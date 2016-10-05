Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33542 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750860AbcJEEIT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 00:08:19 -0400
Received: by mail-oi0-f68.google.com with SMTP id o93so3194651oik.0
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2016 21:08:19 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 0/8] Remove address of Free Software Foundation
Date: Tue,  4 Oct 2016 23:08:02 -0500
Message-Id: <1475640490-5895-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20161005_060824_080029_BF93682E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A number of these drivers were submitted to the kernel before
checkpatch.pl was modified to state that that the address of the
FSF should not be included. This set of patches remove this
information from the sources.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>


Larry Finger (8):
  rtlwifi: rtl8192de: Remove address of Free Software Foundation
  rtlwifi: rtl8192se: Remove address of Free Software Foundation
  rtlwifi: rtl8192ce: Remove address of Free Software Foundation
  rtlwifi: rtl8192cu: Remove address of Free Software Foundation
  rtlwifi: rtl8723ae: Remove address of Free Software Foundation
  rtlwifi: rtl8188ee: Remove address of Free Software Foundation
  rtlwifi: rtl8192c: Remove address of Free Software Foundation
  rtlwifi: Remove address of Free Software Foundation

 drivers/net/wireless/realtek/rtlwifi/pci.c                      | 4 ----
 drivers/net/wireless/realtek/rtlwifi/pci.h                      | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.h             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.h             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.h             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/led.c            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c       | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.h       | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.h       | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192c/main.c            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c      | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.h      | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/def.h            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/dm.c             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/dm.h             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.h             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/led.c            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/led.h            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.h            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/reg.h            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/rf.c             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/rf.h             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.h             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/table.c          | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/table.h          | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.h            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/def.h            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/dm.c             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/dm.h             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.c            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/led.h            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.h            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.c            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/phy.h            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/reg.h            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.h             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.h             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.c          | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/table.h          | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/def.h            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.c             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.h             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.h             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.h             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.c            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.h            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.h            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/reg.h            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/rf.c             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/rf.h             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.h             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/table.c          | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/table.h          | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.h            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/def.h            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/dm.c             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/dm.h             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.c             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/fw.h             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.h             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/led.c            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/led.h            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.h            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/reg.h            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.c             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.h             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.h             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/table.c          | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/table.h          | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.h            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/dm.h             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.h             | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_bt_coexist.h | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.c            | 4 ----
 drivers/net/wireless/realtek/rtlwifi/usb.c                      | 4 ----
 drivers/net/wireless/realtek/rtlwifi/usb.h                      | 4 ----
 96 files changed, 384 deletions(-)

-- 
2.6.6
