Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:41526 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbaGYTxD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2014 15:53:03 -0400
Received: by mail-we0-f177.google.com with SMTP id w62so4767277wes.36
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jul 2014 12:53:02 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/12] staging: vt6656: remove comments of old functions nolonger present.
Date: Fri, 25 Jul 2014 20:51:55 +0100
Message-Id: <1406317916-21884-11-git-send-email-tvboxspy@gmail.com> (sfid-20140725_215326_341418_CD7F9ED7)
In-Reply-To: <1406317916-21884-1-git-send-email-tvboxspy@gmail.com>
References: <1406317916-21884-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c    | 6 ------
 drivers/staging/vt6656/dpc.c     | 5 -----
 drivers/staging/vt6656/usbpipe.c | 1 -
 3 files changed, 12 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 8c0b8fa..98567a7 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -19,15 +19,11 @@
  * File: card.c
  * Purpose: Provide functions to setup NIC operation mode
  * Functions:
- *      s_vSafeResetTx - Rest Tx
  *      vnt_set_rspinf - Set RSPINF
  *      vnt_update_ifs - Update slotTime,SIFS,DIFS, and EIFS
  *      vnt_update_top_rates - Update BasicTopRate
  *      vnt_add_basic_rate - Add to BasicRateSet
- *      CARDbSetBasicRate - Set Basic Tx Rate
  *      vnt_ofdm_min_rate - Check if any OFDM rate is in BasicRateSet
- *      CARDvSetLoopbackMode - Set Loopback mode
- *      CARDbSoftwareReset - Sortware reset NIC
  *      vnt_get_tsf_offset - Calculate TSFOffset
  *      vnt_get_current_tsf - Read Current NIC TSF counter
  *      vnt_get_next_tbtt - Calculate Next Beacon TSF counter
@@ -35,8 +31,6 @@
  *      vnt_update_next_tbtt - Sync. NIC Beacon time
  *      vnt_radio_power_off - Turn Off NIC Radio Power
  *      vnt_radio_power_on - Turn On NIC Radio Power
- *      CARDbSetWEPMode - Set NIC Wep mode
- *      CARDbSetTxPower - Set NIC tx power
  *
  * Revision History:
  *      06-10-2003 Bryan YC Fan:  Re-write codes to support VT3253 spec.
diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 07de768..e6367ed 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -25,11 +25,6 @@
  * Date: May 20, 2003
  *
  * Functions:
- *      device_receive_frame - Rcv 802.11 frame function
- *      s_bHandleRxEncryption- Rcv decrypted data via on-fly
- *      s_byGetRateIdx- get rate index
- *      s_vGetDASA- get data offset
- *      s_vProcessRxMACHeader- Rcv 802.11 and translate to 802.3
  *
  * Revision History:
  *
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index df31ae6..cba6532 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -30,7 +30,6 @@
  *	vnt_control_in - Read variable length bytes from MEM/BB/MAC/EEPROM
  *	vnt_control_out_u8 - Write one byte to MEM/BB/MAC/EEPROM
  *	vnt_control_in_u8 - Read one byte from MEM/BB/MAC/EEPROM
- *      ControlvMaskByte - Read one byte from MEM/BB/MAC/EEPROM and clear/set some bits in the same address
  *
  * Revision History:
  *      04-05-2004 Jerry Chen:  Initial release
-- 
2.0.1

