Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:59985 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbaAYXXr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jan 2014 18:23:47 -0500
Received: by mail-pb0-f41.google.com with SMTP id up15so4559794pbc.14
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jan 2014 15:23:46 -0800 (PST)
From: Connor Behan <connor.behan@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Connor Behan <connor.behan@gmail.com>
Subject: [PATCH] Remove executable permissions from firmware files
Date: Sat, 25 Jan 2014 15:19:06 -0800
Message-Id: <1390691946-6612-1-git-send-email-connor.behan@gmail.com> (sfid-20140126_002415_611225_542C1390)
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should change these permissions unless there is a reason to keep them
executable.

Signed-off-by: Connor Behan <connor.behan@gmail.com>
---
 ar3k/AthrBT_0x41020000.dfu     | Bin
 ar3k/ramps_0x41020000_40.dfu   | Bin
 ar5523.bin                     | Bin
 carl9170fw/carlfw/src/printf.c |   0
 rtlwifi/rtl8723fw.bin          | Bin
 rtlwifi/rtl8723fw_B.bin        | Bin
 6 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 ar3k/AthrBT_0x41020000.dfu
 mode change 100755 => 100644 ar3k/ramps_0x41020000_40.dfu
 mode change 100755 => 100644 ar5523.bin
 mode change 100755 => 100644 carl9170fw/carlfw/src/printf.c
 mode change 100755 => 100644 rtlwifi/rtl8723fw.bin
 mode change 100755 => 100644 rtlwifi/rtl8723fw_B.bin

diff --git a/ar3k/AthrBT_0x41020000.dfu b/ar3k/AthrBT_0x41020000.dfu
old mode 100755
new mode 100644
diff --git a/ar3k/ramps_0x41020000_40.dfu b/ar3k/ramps_0x41020000_40.dfu
old mode 100755
new mode 100644
diff --git a/ar5523.bin b/ar5523.bin
old mode 100755
new mode 100644
diff --git a/carl9170fw/carlfw/src/printf.c b/carl9170fw/carlfw/src/printf.c
old mode 100755
new mode 100644
diff --git a/rtlwifi/rtl8723fw.bin b/rtlwifi/rtl8723fw.bin
old mode 100755
new mode 100644
diff --git a/rtlwifi/rtl8723fw_B.bin b/rtlwifi/rtl8723fw_B.bin
old mode 100755
new mode 100644
-- 
1.8.5.2

