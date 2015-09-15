Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35662 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbbIOFHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 01:07:24 -0400
Received: by pacfv12 with SMTP id fv12so168233881pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2015 22:07:24 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 11/18] staging: wilc1000: remove unused defines
Date: Tue, 15 Sep 2015 14:06:21 +0900
Message-Id: <1442293588-15323-11-git-send-email-chaehyun.lim@gmail.com> (sfid-20150915_071652_559912_D85FD211)
In-Reply-To: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The macros are not used anywhere in this driver, so just delete it.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index a4321a4..f15a878 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -14,8 +14,6 @@
 /*****************************************************************************/
 /*								Macros                                       */
 /*****************************************************************************/
-#define FAIL		0x0000
-#define SUCCESS		0x0001
 
 #define IP_ALEN  4
 
-- 
2.5.1

