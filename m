Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:56674 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbbIOCyR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2015 22:54:17 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 5/7] staging: wilc1000: remove definitions unused
Date: Tue, 15 Sep 2015 11:53:39 +0900
Message-ID: <1442285621-29457-6-git-send-email-tony.cho@atmel.com> (sfid-20150915_045420_658565_85F5F744)
In-Reply-To: <1442285621-29457-1-git-send-email-tony.cho@atmel.com>
References: <1442285621-29457-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

Remove the definitions which are not used anywhere.
- WILC_ALREADY_EXSIT
- WILC_EMPTY
- WILC_FULL
- WILC_CANCELED
- WILC_INVALID_FILE
- WILC_UNSUPPORTED_VERSION
- WILC_FILE_EOF

Remove the definition which is not used anymore.
- WILC_CATCH

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_errorsupport.h | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_errorsupport.h b/drivers/staging/wilc1000/wilc_errorsupport.h
index 99ded3d..054ed76 100644
--- a/drivers/staging/wilc1000/wilc_errorsupport.h
+++ b/drivers/staging/wilc1000/wilc_errorsupport.h
@@ -12,9 +12,6 @@
 
 #include "linux_wlan_common.h"
 
-/* Psitive Numbers to indicate sucess with special status */
-#define WILC_ALREADY_EXSIT	(+100)    /** The requested object already exists */
-
 /* Generic success will return 0 */
 #define WILC_SUCCESS	0       /** Generic success */
 
@@ -25,22 +22,8 @@
 #define WILC_INVALID_STATE		-103 /** An API request would violate the Driver state machine (i.e. to start PID while not camped)*/
 #define WILC_BUFFER_OVERFLOW		-104 /** In copy operations if the copied data is larger than the allocated buffer*/
 #define WILC_NULL_PTR			-105 /** null pointer is passed or used */
-#define WILC_EMPTY			-107
-#define WILC_FULL			-108
 #define WILC_TIMEOUT			-109
-#define WILC_CANCELED			-110 /** The required operation have been canceled by the user*/
-#define WILC_INVALID_FILE		-112 /** The Loaded file is corruped or having an invalid format */
 #define WILC_NOT_FOUND			-113 /** Cant find the file to load */
 #define WILC_NO_MEM			-114
-#define WILC_UNSUPPORTED_VERSION	-115
-#define WILC_FILE_EOF			-116
-
-
-
-
-
-#define WILC_CATCH(__status__) \
-ERRORHANDLER: \
-	if (__status__ < WILC_SUCCESS) \
 
 #endif
-- 
1.9.1

