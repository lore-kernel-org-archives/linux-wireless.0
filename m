Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:5637 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbbIPBoY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 21:44:24 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 04/10] staging: wilc1000: remove unused defines
Date: Wed, 16 Sep 2015 10:43:49 +0900
Message-ID: <1442367835-30733-5-git-send-email-tony.cho@atmel.com> (sfid-20150916_034426_480818_DB094701)
In-Reply-To: <1442367835-30733-1-git-send-email-tony.cho@atmel.com>
References: <1442367835-30733-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch removes follwing unused defines.
MAX_CFG_PKTLEN
MSG_HEADER_LEN
QUERY_MSG_TYPE
WRITE_MSG_TYPE
RESP_MSG_TYPE
WRITE_RESP_SUCCESS
INVALID
MAC_ADDR_LEN

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index ac3da88..a0b0d97 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -17,14 +17,6 @@
 /* Constants                                                                 */
 /*****************************************************************************/
 #define INLINE static __inline
-#define MAX_CFG_PKTLEN     1450
-#define MSG_HEADER_LEN     4
-#define QUERY_MSG_TYPE     'Q'
-#define WRITE_MSG_TYPE     'W'
-#define RESP_MSG_TYPE      'R'
-#define WRITE_RESP_SUCCESS 1
-#define INVALID         255
-#define MAC_ADDR_LEN    6
 #define TAG_PARAM_OFFSET	(MAC_HDR_LEN + TIME_STAMP_LEN + \
 							BEACON_INTERVAL_LEN + CAP_INFO_LEN)
 
-- 
1.9.1

