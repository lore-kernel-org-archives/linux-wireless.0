Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:48083 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbbG1ItY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 04:49:24 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 12/21] staging: wilc1000: alignment should match open parenthesis
Date: Tue, 28 Jul 2015 17:47:31 +0900
Message-ID: <1438073261-28315-13-git-send-email-tony.cho@atmel.com> (sfid-20150728_104931_544298_09BB08C4)
In-Reply-To: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
References: <1438073261-28315-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Jude.Lee" <jude.lee@atmel.com>

This patch fixes the checks reported by checkpatch.pl
alignment should match open parenthesis

Signed-off-by: Jude.Lee <jude.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 3b4b01b..56ff2ba 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -167,17 +167,18 @@ extern s32 CoreConfiguratorInit(void);
 extern s32 CoreConfiguratorDeInit(void);
 
 extern s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
-				 u32 u32WIDsCount, bool bRespRequired, u32 drvHandler);
+			 u32 u32WIDsCount, bool bRespRequired, u32 drvHandler);
 extern s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo);
 extern s32 DeallocateNetworkInfo(tstrNetworkInfo *pstrNetworkInfo);
 
 extern s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
-				      tstrConnectRespInfo **ppstrConnectRespInfo);
+			      tstrConnectRespInfo **ppstrConnectRespInfo);
 extern s32 DeallocateAssocRespInfo(tstrConnectRespInfo *pstrConnectRespInfo);
 
 #ifndef CONNECT_DIRECT
 extern s32 ParseSurveyResults(u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZE],
-				      wid_site_survey_reslts_s **ppstrSurveyResults, u32 *pu32SurveyResultsCount);
+			      wid_site_survey_reslts_s **ppstrSurveyResults,
+			      u32 *pu32SurveyResultsCount);
 extern s32 DeallocateSurveyResults(wid_site_survey_reslts_s *pstrSurveyResults);
 #endif
 
-- 
1.9.1

