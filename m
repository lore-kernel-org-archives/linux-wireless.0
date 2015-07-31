Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:37076 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbbGaFcv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 01:32:51 -0400
From: Shraddha Barke <shraddha.6596@gmail.com>
To: Dean Lee <dean.lee@atmel.com>, Rachel Kim <rachel.kim@atmel.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Cc: Shraddha Barke <shraddha.6596@gmail.com>
Subject: [PATCH] Staging : wilc1000 :Remove typedef from struct
Date: Fri, 31 Jul 2015 11:02:32 +0530
Message-Id: <1438320752-7921-1-git-send-email-shraddha.6596@gmail.com> (sfid-20150731_073310_282566_591845A2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the following checkpatch.pl warning:

WARNING: do not add new typedefs
Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 0f31d63..54eb8a1 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -140,7 +140,7 @@ typedef enum {
 } tenuInfoElemID;
 
 
-typedef struct {
+struct {
 	char *pcRespBuffer;
 	s32 s32MaxRespBuffLen;
 	s32 s32BytesRead;
-- 
2.1.0

