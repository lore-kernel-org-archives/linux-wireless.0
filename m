Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34061 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933013AbbJANog (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 09:44:36 -0400
Received: by padhy16 with SMTP id hy16so75404254pad.1
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2015 06:44:36 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 09/12] staging: wilc1000: set_channel: remove blank line after open brace
Date: Thu,  1 Oct 2015 22:43:56 +0900
Message-Id: <1443707039-18433-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20151001_154439_509365_6AE7822C)
In-Reply-To: <1443707039-18433-1-git-send-email-chaehyun.lim@gmail.com>
References: <1443707039-18433-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes blank line after open brace '{' found by
checkpatch.pl

CHECK: Blank lines aren't necessary after an open brace '{'
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:664:

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 56c97c9..732d631 100644
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

