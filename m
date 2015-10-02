Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35941 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbbJBHl4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 03:41:56 -0400
Received: by pablk4 with SMTP id lk4so99280420pab.3
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2015 00:41:55 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 09/12] staging: wilc1000: set_channel: remove blank line after open brace
Date: Fri,  2 Oct 2015 16:41:18 +0900
Message-Id: <1443771681-15540-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20151002_094158_688256_8C3E1138)
In-Reply-To: <1443771681-15540-1-git-send-email-chaehyun.lim@gmail.com>
References: <1443771681-15540-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes blank line after open brace '{' found by
checkpatch.pl

CHECK: Blank lines aren't necessary after an open brace '{'
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:664:

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: resend because 08/12 patch is changed.

 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 3c8c2e1..f98a807 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -661,7 +661,6 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 static int set_channel(struct wiphy *wiphy,
 		       struct cfg80211_chan_def *chandef)
 {
-
 	u32 channelnum = 0;
 	struct wilc_priv *priv;
 	s32 s32Error = 0;
-- 
2.6.0

