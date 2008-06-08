Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:45416 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756273AbYFHVhs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2008 17:37:48 -0400
Received: by ug-out-1314.google.com with SMTP id h2so1022998ugf.16
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jun 2008 14:37:47 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 09/10] rt2x00: Remove unused defines
Date: Sun, 8 Jun 2008 23:46:27 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200806082341.58616.IvDoorn@gmail.com> <200806082345.49841.IvDoorn@gmail.com> <200806082346.06848.IvDoorn@gmail.com>
In-Reply-To: <200806082346.06848.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806082346.27372.IvDoorn@gmail.com> (sfid-20080608_233751_107541_75A3959E)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

MAX_RX_SSI and MAX_NOISE are no longer used,
it is better to remove them entirely.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.h |    2 --
 drivers/net/wireless/rt2x00/rt2500pci.h |    2 --
 drivers/net/wireless/rt2x00/rt2500usb.h |    2 --
 drivers/net/wireless/rt2x00/rt61pci.h   |    2 --
 drivers/net/wireless/rt2x00/rt73usb.h   |    2 --
 5 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
index e9aa326..bc55642 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/rt2x00/rt2400pci.h
@@ -37,8 +37,6 @@
  * Signal information.
  * Defaul offset is required for RSSI <-> dBm conversion.
  */
-#define MAX_SIGNAL			100
-#define MAX_RX_SSI			-1
 #define DEFAULT_RSSI_OFFSET		100
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.h b/drivers/net/wireless/rt2x00/rt2500pci.h
index ea93b8f..cb648c3 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/rt2x00/rt2500pci.h
@@ -48,8 +48,6 @@
  * Signal information.
  * Defaul offset is required for RSSI <-> dBm conversion.
  */
-#define MAX_SIGNAL			100
-#define MAX_RX_SSI			-1
 #define DEFAULT_RSSI_OFFSET		121
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
index 7d50098..3e21fdf 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -48,8 +48,6 @@
  * Signal information.
  * Defaul offset is required for RSSI <-> dBm conversion.
  */
-#define MAX_SIGNAL			100
-#define MAX_RX_SSI			-1
 #define DEFAULT_RSSI_OFFSET		120
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index c5a04b9..1004d5b 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -39,8 +39,6 @@
  * Signal information.
  * Defaul offset is required for RSSI <-> dBm conversion.
  */
-#define MAX_SIGNAL			100
-#define MAX_RX_SSI			-1
 #define DEFAULT_RSSI_OFFSET		120
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
index 25cdcc9..1484935 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -39,8 +39,6 @@
  * Signal information.
  * Defaul offset is required for RSSI <-> dBm conversion.
  */
-#define MAX_SIGNAL			100
-#define MAX_RX_SSI			-1
 #define DEFAULT_RSSI_OFFSET		120
 
 /*
-- 
1.5.5.3

