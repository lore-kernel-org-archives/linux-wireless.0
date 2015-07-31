Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:36345 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbbGaFQQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 01:16:16 -0400
From: Shraddha Barke <shraddha.6596@gmail.com>
To: Dean Lee <dean.lee@atmel.com>, Rachel Kim <rachel.kim@atmel.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Cc: Shraddha Barke <shraddha.6596@gmail.com>
Subject: [PATCH] Staging:wilc1000 :Remove braces for single statement blocks
Date: Fri, 31 Jul 2015 10:45:55 +0530
Message-Id: <1438319755-7438-1-git-send-email-shraddha.6596@gmail.com> (sfid-20150731_071636_331420_3757E52F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the following checkpatch.pl warning:

WARNING: braces {} are not necessary for single statement blocks
Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 4d5bd1c..1143282 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -1055,10 +1055,8 @@ s32 DeallocateSurveyResults(wid_site_survey_reslts_s *pstrSurveyResults)
 {
 	s32 s32Error = WILC_SUCCESS;
 
-	if (pstrSurveyResults != NULL) {
+	if (pstrSurveyResults != NULL)
 		WILC_FREE(pstrSurveyResults);
-	}
-
 	return s32Error;
 }
 #endif
-- 
2.1.0

