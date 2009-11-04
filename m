Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:40568 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413AbZKDRf7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 12:35:59 -0500
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:35:39 +0100
Message-Id: <20091104173539.28463.82770.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 30/41] rt2800usb: fix comments in rt2800usb.h
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800usb: fix comments in rt2800usb.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800usb.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.h
+++ b/drivers/net/wireless/rt2x00/rt2800usb.h
@@ -61,7 +61,7 @@
 
 /*
  * Signal information.
- * Defaul offset is required for RSSI <-> dBm conversion.
+ * Default offset is required for RSSI <-> dBm conversion.
  */
 #define DEFAULT_RSSI_OFFSET		120 /* FIXME */
 
@@ -87,12 +87,6 @@
  */
 
 /*
- * HOST-MCU shared memory
- */
-#define HOST_CMD_CSR			0x0404
-#define HOST_CMD_CSR_HOST_COMMAND	FIELD32(0x000000ff)
-
-/*
  * INT_SOURCE_CSR: Interrupt source register.
  * Write one to clear corresponding bit.
  * TX_FIFO_STATUS: FIFO Statistics is full, sw should read 0x171c
@@ -351,6 +345,12 @@
 #define PBF_SYS_CTRL_HOST_RAM_WRITE	FIELD32(0x00010000)
 
 /*
+ * HOST-MCU shared memory
+ */
+#define HOST_CMD_CSR			0x0404
+#define HOST_CMD_CSR_HOST_COMMAND	FIELD32(0x000000ff)
+
+/*
  * PBF registers
  * Most are for debug. Driver doesn't touch PBF register.
  */
@@ -1776,7 +1776,7 @@ struct mac_iveiv_entry {
 
 /*
  * Word3
- * WIV: Wireless Info Valid. 1: Driver filled WI,  0: DMA needs to copy WI
+ * WIV: Wireless Info Valid. 1: Driver filled WI, 0: DMA needs to copy WI
  * QSEL: Select on-chip FIFO ID for 2nd-stage output scheduler.
  *       0:MGMT, 1:HCCA 2:EDCA
  */
