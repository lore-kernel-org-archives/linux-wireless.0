Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:32907 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaBJJaC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 04:30:02 -0500
Received: by mail-wg0-f52.google.com with SMTP id b13so3907861wgh.31
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 01:30:01 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: Ben Hutchings <ben@decadent.org.uk>,
	<linux-wireless@vger.kernel.org>
Cc: Arik Nemtsov <arik@wizery.com>
Subject: linux-firmware: pull-request TI wireless firmware 2014-02-10
Date: Mon, 10 Feb 2014 11:29:56 +0200
Message-Id: <1392024596-22285-1-git-send-email-arik@wizery.com> (sfid-20140210_103011_903401_0F1D36C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Ben,

Here's an updated FW for the Wilink 8 chip. The name change is due to changes
in some driver/FW APIs. Sorry for the double send, adding the linux-wireless
list now as well.

The following changes since commit 4164c23d2e3b4863ca42d72f40dc7cc5d9fb8c6c:

  rtlwifi: Add firmware for rtl8192ee (2014-02-09 13:26:05 +0000)

are available in the git repository at:

  git://github.com/TI-OpenLink/firmwares.git master

for you to fetch changes up to 7f9cf6ebdedb4776d3c977003b9a7e33537014b2:

  wl18xx: add version 3 of the wl18xx firmware (2014-02-10 11:02:23 +0200)

----------------------------------------------------------------
Arik Nemtsov (1):
      wl18xx: add version 3 of the wl18xx firmware

 WHENCE                          |   2 ++
 ti-connectivity/wl18xx-fw-3.bin | Bin 0 -> 673328 bytes
 2 files changed, 2 insertions(+)
 create mode 100644 ti-connectivity/wl18xx-fw-3.bin

diff --git a/WHENCE b/WHENCE
index a5c0444..7263c1d 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1835,6 +1835,8 @@ File: ti-connectivity/wl18xx-fw.bin
 Version: 8.2.0.0.100
 File: ti-connectivity/wl18xx-fw-2.bin
 Version: 8.5.0.0.55
+File: ti-connectivity/wl18xx-fw-3.bin
+Version: 8.8.0.0.13
 File: ti-connectivity/wl18xx-conf.bin
 Version: 6/5
 
diff --git a/ti-connectivity/wl18xx-fw-3.bin b/ti-connectivity/wl18xx-fw-3.bin
new file mode 100644
index 0000000..3c799a3
Binary files /dev/null and b/ti-connectivity/wl18xx-fw-3.bin differ
