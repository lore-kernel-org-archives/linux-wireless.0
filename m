Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:59664 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbbIOFeF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 01:34:05 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 2/4] staging: wilc1000: delete function declaration SendRawPacket
Date: Tue, 15 Sep 2015 14:33:55 +0900
Message-ID: <1442295237-12644-2-git-send-email-tony.cho@atmel.com> (sfid-20150915_073416_365026_E0890F28)
In-Reply-To: <1442295237-12644-1-git-send-email-tony.cho@atmel.com>
References: <1442295237-12644-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

SendRawpacket is declared but not implemented. It is not used also.
So just delete it.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index d2a0a0b..c2aee05 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -180,7 +180,6 @@ s32 ParseSurveyResults(u8 ppu8RcvdSiteSurveyResults[][MAX_SURVEY_RESULT_FRAG_SIZ
 s32 DeallocateSurveyResults(wid_site_survey_reslts_s *pstrSurveyResults);
 #endif
 
-s32 SendRawPacket(s8 *pspacket, s32 s32PacketLen);
 void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length);
 void GnrlAsyncInfoReceived(u8 *pu8Buffer, u32 u32Length);
 void host_int_ScanCompleteReceived(u8 *pu8Buffer, u32 u32Length);
-- 
1.9.1

