Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34683 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbbGaFjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 01:39:05 -0400
From: Shraddha Barke <shraddha.6596@gmail.com>
To: Dean Lee <dean.lee@atmel.com>, Rachel Kim <rachel.kim@atmel.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Cc: Shraddha Barke <shraddha.6596@gmail.com>
Subject: [PATCH] Staging:wilc1000 :Remove typedef from struct
Date: Fri, 31 Jul 2015 11:08:47 +0530
Message-Id: <1438321127-8120-1-git-send-email-shraddha.6596@gmail.com> (sfid-20150731_073909_820506_D7540577)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the following checkpatch.pl warning:

WARNING: do not add new typedefs

Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 54eb8a1..d6ef6e1 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -88,7 +88,7 @@ typedef enum {
 } tenuFrmSubtype;
 
 /* Basic Frame Classes */
-typedef enum {
+enum {
 	CLASS1_FRAME_TYPE      = 0x00,
 	CLASS2_FRAME_TYPE      = 0x01,
 	CLASS3_FRAME_TYPE      = 0x02,
-- 
2.1.0

