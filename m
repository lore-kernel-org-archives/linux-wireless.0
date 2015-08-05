Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36140 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbbHEQm3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 12:42:29 -0400
From: Chandra S Gorentla <csgorentla@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Chandra S Gorentla <csgorentla@gmail.com>
Subject: [PATCH v3 2/3] drivers: staging: wilc1000: move { to previous line
Date: Wed,  5 Aug 2015 22:11:56 +0530
Message-Id: <1438792917-9817-3-git-send-email-csgorentla@gmail.com> (sfid-20150805_184306_638918_E85449D8)
In-Reply-To: <1438792917-9817-2-git-send-email-csgorentla@gmail.com>
References: <1438792917-9817-1-git-send-email-csgorentla@gmail.com>
 <1438792917-9817-2-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moved the opening brace of code blocks to the previous lines.  This
fixes the checkpatch.pl error - "that open brace { should be on the
previous line".

Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c2ef46f..779ec5a 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1205,8 +1205,7 @@ static int WILC_WFI_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 k
 
 
 
-			if (!pairwise)
-			{
+			if (!pairwise) {
 				if (params->cipher == WLAN_CIPHER_SUITE_TKIP)
 					u8gmode = ENCRYPT_ENABLED | WPA | TKIP;
 				else
@@ -1304,8 +1303,7 @@ static int WILC_WFI_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 k
 
 		{
 			u8mode = 0;
-			if (!pairwise)
-			{
+			if (!pairwise) {
 				if (params->key_len > 16 && params->cipher == WLAN_CIPHER_SUITE_TKIP) {
 					/* swap the tx mic by rx mic */
 					pu8RxMic = params->key + 24;
@@ -1531,8 +1529,7 @@ static int WILC_WFI_get_key(struct wiphy *wiphy, struct net_device *netdev, u8 k
 	priv = wiphy_priv(wiphy);
 
 
-	if (!pairwise)
-	{
+	if (!pairwise) {
 		PRINT_D(CFG80211_DBG, "Getting group key idx: %x\n", key_index);
 
 		key_params.key = priv->wilc_gtk[key_index]->key;
-- 
2.5.0

