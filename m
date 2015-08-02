Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36589 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbbHBPzR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2015 11:55:17 -0400
From: Chandra S Gorentla <csgorentla@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Chandra S Gorentla <csgorentla@gmail.com>
Subject: [PATCH 3/3] drivers: staging: wilc1000: remove space after '('
Date: Sun,  2 Aug 2015 21:23:53 +0530
Message-Id: <1438530833-24640-4-git-send-email-csgorentla@gmail.com> (sfid-20150802_175546_775815_35E94707)
In-Reply-To: <1438530833-24640-3-git-send-email-csgorentla@gmail.com>
References: <1438530833-24640-1-git-send-email-csgorentla@gmail.com>
 <1438530833-24640-2-git-send-email-csgorentla@gmail.com>
 <1438530833-24640-3-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The character ' ' is removed after the character '('.  This fixes the
checkpatch.pl error - "space prohibited after that open
parenthesis '('".

Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index b995056..c3be9ed 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1675,7 +1675,7 @@ static int WILC_WFI_get_station(struct wiphy *wiphy, struct net_device *dev,
 		 * kernel version 3.0.0
 		 */
 		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL) |
-						BIT( NL80211_STA_INFO_RX_PACKETS) |
+						BIT(NL80211_STA_INFO_RX_PACKETS) |
 						BIT(NL80211_STA_INFO_TX_PACKETS) |
 						BIT(NL80211_STA_INFO_TX_FAILED) |
 						BIT(NL80211_STA_INFO_TX_BITRATE);
-- 
2.5.0

