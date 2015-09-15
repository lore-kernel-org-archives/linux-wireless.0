Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:59691 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbbIOFeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 01:34:12 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 3/4] staging: wilc1000: coreconfigurator.h: remove unused defines
Date: Tue, 15 Sep 2015 14:33:56 +0900
Message-ID: <1442295237-12644-3-git-send-email-tony.cho@atmel.com> (sfid-20150915_073418_460349_DF0E7464)
In-Reply-To: <1442295237-12644-1-git-send-email-tony.cho@atmel.com>
References: <1442295237-12644-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

The define MAX_PACKET_BUFF_SIZE and STATUS_MSG_LEN is not used in the driver.
Delete two defines.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index c2aee05..32e5b31 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -44,14 +44,11 @@
 /* Operating Mode: GET */
 #define GET_CFG              1
 
-#define MAX_PACKET_BUFF_SIZE 1596
-
 #define MAX_STRING_LEN               256
 #define MAX_SURVEY_RESULT_FRAG_SIZE  MAX_STRING_LEN
 #define SURVEY_RESULT_LENGTH         44
 #define MAX_ASSOC_RESP_FRAME_SIZE    MAX_STRING_LEN
 
-#define STATUS_MSG_LEN               12
 #define MAC_CONNECTED                1
 #define MAC_DISCONNECTED             0
 
-- 
1.9.1

