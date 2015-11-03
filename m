Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8853 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbbKCHR7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 02:17:59 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 1/5] staging: wilc1000: change enum variable name with lower case
Date: Tue, 3 Nov 2015 16:20:58 +0900
Message-ID: <1446535262-19817-1-git-send-email-glen.lee@atmel.com> (sfid-20151103_081802_355967_02500497)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes WID_TYPE with wid_type which is preferred style.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.h | 2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 1ea5f47..7545856 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -72,7 +72,7 @@ typedef enum {
 
 struct wid {
 	u16 id;
-	enum WID_TYPE type;
+	enum wid_type type;
 	s32 size;
 	s8 *val;
 };
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 1170169..be90558 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -312,7 +312,7 @@ typedef enum {
 	SW_TRIGGER_ABORT,
 } TX_ABORT_OPTION_T;
 
-enum WID_TYPE {
+enum wid_type {
 	WID_CHAR		= 0,
 	WID_SHORT		= 1,
 	WID_INT			= 2,
-- 
1.9.1

