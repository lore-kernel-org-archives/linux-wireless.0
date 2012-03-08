Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35275 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab2CGXaF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 18:30:05 -0500
Received: by iagz16 with SMTP id z16so9301492iag.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Mar 2012 15:30:04 -0800 (PST)
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>
Subject: [PATCH] net/wireless: ipw2x00: remove WEXT_USECHANNELS define
Date: Wed,  7 Mar 2012 19:32:40 -0500
Message-Id: <1331166760-7080-1-git-send-email-stas.yakovlev@gmail.com> (sfid-20120308_003010_144824_D06885C9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver does not use it any more.

Signed-off-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
---
 drivers/net/wireless/ipw2x00/ipw2100.c |    2 --
 drivers/net/wireless/ipw2x00/ipw2200.h |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index 5d7e97e..ddf340f 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -298,8 +298,6 @@ static const char *command_types[] = {
 };
 #endif
 
-#define WEXT_USECHANNELS 1
-
 static const long ipw2100_frequencies[] = {
 	2412, 2417, 2422, 2427,
 	2432, 2437, 2442, 2447,
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.h b/drivers/net/wireless/ipw2x00/ipw2200.h
index ecb561d..66e84ec 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.h
+++ b/drivers/net/wireless/ipw2x00/ipw2200.h
@@ -27,8 +27,6 @@
 #ifndef __ipw2200_h__
 #define __ipw2200_h__
 
-#define WEXT_USECHANNELS 1
-
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
-- 
1.7.2.5

