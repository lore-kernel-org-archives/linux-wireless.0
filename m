Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:50976 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbbFLKX6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2015 06:23:58 -0400
From: Dean Lee <dean.lee@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>
CC: <johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <dean.lee@atmel.com>
Subject: [PATCH] staging: wilc1000: update TODO list
Date: Fri, 12 Jun 2015 19:23:11 +0900
Message-ID: <1434104591-5599-1-git-send-email-dean.lee@atmel.com> (sfid-20150612_122401_200007_C21D6841)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove complete OS wrapper functions.

Signed-off-by: Dean Lee <dean.lee@atmel.com>
---
 drivers/staging/wilc1000/TODO | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/TODO b/drivers/staging/wilc1000/TODO
index 95199d8..e876008 100644
--- a/drivers/staging/wilc1000/TODO
+++ b/drivers/staging/wilc1000/TODO
@@ -1,6 +1,5 @@
 TODO:
 - remove the defined feature as kernel versions
-- remove OS wrapper functions
 - remove custom debug and tracing functions
 - rework comments and function headers(also coding style)
 - replace all semaphores with mutexes or completions
-- 
2.4.3

