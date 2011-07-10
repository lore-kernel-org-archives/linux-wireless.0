Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:40583 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751535Ab1GJHAT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jul 2011 03:00:19 -0400
Received: by gxk10 with SMTP id 10so1832478gxk.39
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jul 2011 00:00:18 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 10 Jul 2011 09:55:00 +0300
Message-ID: <CAHiDVwnX34yXka_fU-FA8mt4AWEuMdpwiGsdmKfbpeBi0k796g@mail.gmail.com> (sfid-20110710_090024_367038_2C3C82EE)
Subject: pull request: linux-firmware - ti-connectivity 2011-07-11
From: "Levi, Shahar" <shahar_levi@ti.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear David,
This is a pull request to update TI connectivity FW (more friendly to
linux-wireless list than binaries patches).
It updates the STA and AP FWs for wl128x and wl127x (wl12xx driver)

    Update FW for WL128x chip:
    STA FW version 7.1.5.50.74
    AP FW version 7.2.1.0.54

   Update FW for WL127x chip:
    STA FW version 6.1.5.50.74
    AP FW version 6.2.1.0.54

Please let me know if there are problems!

All the best,
Shahar
---

The following changes since commit f6f644b37083bb5dd22e5da1d9ee25457803f153:

 ath9k_htc: Update firmware to version 1.3 (2011-06-25 19:19:14 +0100)

are available in the git repository at:
 git://github.com/shaharlevi/linux-firmware-ti-connectivity.git ti-connectivity

Shahar Levi (1):
     linux-firmware: wl12xx: Updated STA & AP FW for WL128x & wl127x

 WHENCE                           |    8 ++++----
 ti-connectivity/wl1271-fw-2.bin  |  Bin 273252 -> 273880 bytes
 ti-connectivity/wl1271-fw-ap.bin |  Bin 272784 -> 272836 bytes
 ti-connectivity/wl128x-fw-ap.bin |  Bin 265196 -> 265460 bytes
 ti-connectivity/wl128x-fw.bin    |  Bin 272748 -> 273324 bytes
 5 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/WHENCE b/WHENCE
index b037a29..f2e192b 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1525,10 +1525,10 @@ File: wl1271-nvs-example-wl128x.bin
 Licence: See LICENCE.ti-connectivity for details.

       Station:      wl1271-fw.bin version 6.1.0.50.350
-       Station:      wl1271-fw-2.bin version 6.1.3.50.58
-       Station:      wl128x-fw.bin version 7.1.3.50.58
-       Access Point: wl1271-fw-ap.bin version 6.2.0.0.47
-       Access Point: wl128x-fw-ap.bin version 7.2.0.0.47
+       Station:      wl1271-fw-2.bin version 6.1.5.50.74
+       Station:      wl128x-fw.bin version 7.1.5.50.74
+       Access Point: wl1271-fw-ap.bin version 6.2.1.0.54
+       Access Point: wl128x-fw-ap.bin version 7.2.1.0.54

 The nvs file includes two parts:
        - radio calibration
diff --git a/ti-connectivity/wl1271-fw-2.bin b/ti-connectivity/wl1271-fw-2.bin
index 8d18611..a01324e 100644
Binary files a/ti-connectivity/wl1271-fw-2.bin and
b/ti-connectivity/wl1271-fw-2.bin differ
diff --git a/ti-connectivity/wl1271-fw-ap.bin b/ti-connectivity/wl1271-fw-ap.bin
index c145a71..3a8e570 100644
Binary files a/ti-connectivity/wl1271-fw-ap.bin and
b/ti-connectivity/wl1271-fw-ap.bin differ
diff --git a/ti-connectivity/wl128x-fw-ap.bin b/ti-connectivity/wl128x-fw-ap.bin
index 51d307b..3795717 100644
Binary files a/ti-connectivity/wl128x-fw-ap.bin and
b/ti-connectivity/wl128x-fw-ap.bin differ
diff --git a/ti-connectivity/wl128x-fw.bin b/ti-connectivity/wl128x-fw.bin
index bf5344f..0fbf626 100755
Binary files a/ti-connectivity/wl128x-fw.bin and
b/ti-connectivity/wl128x-fw.bin differ
