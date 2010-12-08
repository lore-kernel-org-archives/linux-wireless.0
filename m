Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2558 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756685Ab0LHVSS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 16:18:18 -0500
From: "Henry Ptasinski" <henryp@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH] staging: brcm80211: fix documentation on installing
 firmware
Date: Wed, 8 Dec 2010 13:18:04 -0800
Message-ID: <1291843084-9789-1-git-send-email-henryp@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the documentation to have the current firmware filenames and use the
correct path.

Signed-off-by: Henry Ptasinski <henryp@broadcom.com>
---
 drivers/staging/brcm80211/README          |   10 ++--------
 drivers/staging/brcm80211/brcmfmac/README |    5 +++--
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/brcm80211/README b/drivers/staging/brcm80211/README
index de65f9d..8e335b8 100644
--- a/drivers/staging/brcm80211/README
+++ b/drivers/staging/brcm80211/README
@@ -43,14 +43,8 @@ Firmware is available from the Linux firmware repository at:
 	http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git
 	https://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git
 
-For all chips, copy brcm/bcm43xx-0-610-809-0.fw and
-brcm/bcm43xx_hdr-0-610-809-0.fw to /lib/firmware/brcm (or wherever firmware is
-normally installed on the system).  In the /lib/firmware/brcm directory, then
-create the following symlinks:
-
-	ln -s bcm43xx-0-610-809-0.fw bcm43xx-0.fw
-	ln -s bcm43xx_hdr-0-610-809-0.fw bcm43xx_hdr-0.fw
-
+For all chips, copy brcm/bcm43xx-0.fw and brcm/bcm43xx_hdr-0.fw to
+/lib/firmware/brcm (or wherever firmware is normally installed on your system).
 
 Currently supported chips
 ==============
diff --git a/drivers/staging/brcm80211/brcmfmac/README b/drivers/staging/brcm80211/brcmfmac/README
index 43601fa..be29e42 100644
--- a/drivers/staging/brcm80211/brcmfmac/README
+++ b/drivers/staging/brcm80211/brcmfmac/README
@@ -25,8 +25,9 @@ Firmware is available from the Linux firmware repository at:
 	http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git
 	https://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git
 
-For 4329 chip, copy brcm/bcm4329-fullmac-4-218-248-5.bin and
-bcm4329-fullmac-4-218-248-5.txt to /lib/firmware/brcm
+For 4329 chip, copy brcm/bcm4329-fullmac-4.bin and brcm/bcm4329-fullmac-4.txt
+to /lib/firmware/brcm (or wherever firmware is normally installed on your
+system).
 
 Contact Info:
 =============
-- 
1.7.1


