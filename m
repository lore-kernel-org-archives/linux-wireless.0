Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36356 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbbITGvt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 02:51:49 -0400
Received: by padhk3 with SMTP id hk3so87319449pad.3
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2015 23:51:48 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 04/18] staging: wilc1000: remove blank line after an open brace '{'
Date: Sun, 20 Sep 2015 15:51:11 +0900
Message-Id: <1442731885-4344-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20150920_085210_588412_6194E6A2)
In-Reply-To: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes blank line after an open brace '{' found by checkpatch.pl.
CHECK: Blank lines aren't necessary after an open brace '{'

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index af11af3..8107420 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3691,7 +3691,6 @@ int WILC_WFI_DeInitHostInt(struct net_device *net)
  */
 void wilc_free_wiphy(struct net_device *net)
 {
-
 	PRINT_D(CFG80211_DBG, "Unregistering wiphy\n");
 
 	if (!net) {
-- 
2.5.1

