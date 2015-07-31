Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33434 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbbGaFZ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 01:25:57 -0400
From: Shraddha Barke <shraddha.6596@gmail.com>
To: Dean Lee <dean.lee@atmel.com>, Rachel Kim <rachel.kim@atmel.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Cc: Shraddha Barke <shraddha.6596@gmail.com>
Subject: [PATCH] Staging: wilc1000 :Insert blank line after declaration
Date: Fri, 31 Jul 2015 10:55:40 +0530
Message-Id: <1438320340-7716-1-git-send-email-shraddha.6596@gmail.com> (sfid-20150731_072617_961998_F1DC3DB7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the following checkpatch.pl warning:

WARNING: Missing a blank line after declarations
Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 1143282..0f31d63 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -1094,6 +1094,7 @@ void ProcessCharWid(char *pcPacket, s32 *ps32PktLen,
 	u8 *pu8val = (u8 *)ps8WidVal;
 	u8 u8val = 0;
 	s32 s32PktLen = *ps32PktLen;
+
 	if (pstrWID == NULL) {
 		PRINT_WRN(CORECONFIG_DBG, "Can't set CHAR val 0x%x ,NULL structure\n", u8val);
 		return;
-- 
2.1.0

