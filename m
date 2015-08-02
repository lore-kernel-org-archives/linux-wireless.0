Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35821 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbbHBPzH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2015 11:55:07 -0400
From: Chandra S Gorentla <csgorentla@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Chandra S Gorentla <csgorentla@gmail.com>
Subject: [PATCH 2/3] drivers: staging: wilc1000: move { to previous line
Date: Sun,  2 Aug 2015 21:23:52 +0530
Message-Id: <1438530833-24640-3-git-send-email-csgorentla@gmail.com> (sfid-20150802_175554_772083_9C21BCE9)
In-Reply-To: <1438530833-24640-2-git-send-email-csgorentla@gmail.com>
References: <1438530833-24640-1-git-send-email-csgorentla@gmail.com>
 <1438530833-24640-2-git-send-email-csgorentla@gmail.com>
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
index 1d0b7f8..b995056 100644
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

