Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34063 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbbITGw0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 02:52:26 -0400
Received: by padhy16 with SMTP id hy16so87438436pad.1
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2015 23:52:25 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 16/18] staging: wilc1000: replace s32 with int
Date: Sun, 20 Sep 2015 15:51:23 +0900
Message-Id: <1442731885-4344-16-git-send-email-chaehyun.lim@gmail.com> (sfid-20150920_091654_185754_C6E1D226)
In-Reply-To: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes date type of s32Error as int.
The return type of WILC_WFI_InitHostInt and WILC_WFI_DeInitHostInt is int
so that data type of this variable is changed by int.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index fce7dac..ee4cc7f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3602,7 +3602,7 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net)
 int WILC_WFI_InitHostInt(struct net_device *net)
 {
 
-	s32 s32Error = 0;
+	int s32Error = 0;
 
 	struct wilc_priv *priv;
 
@@ -3643,7 +3643,7 @@ int WILC_WFI_InitHostInt(struct net_device *net)
  */
 int WILC_WFI_DeInitHostInt(struct net_device *net)
 {
-	s32 s32Error = 0;
+	int s32Error = 0;
 
 	struct wilc_priv *priv;
 
-- 
2.5.1

