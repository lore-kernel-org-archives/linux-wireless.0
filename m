Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f195.google.com ([209.85.192.195]:33048 "EHLO
	mail-pd0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932814AbbHHMMk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2015 08:12:40 -0400
From: Chandra S Gorentla <csgorentla@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Chandra S Gorentla <csgorentla@gmail.com>
Subject: [PATCH 1/4] staging: wilc1000: Add space between the braces
Date: Sat,  8 Aug 2015 17:41:33 +0530
Message-Id: <1439035896-15213-2-git-send-email-csgorentla@gmail.com> (sfid-20150808_141321_345266_B5E82299)
In-Reply-To: <1439035896-15213-1-git-send-email-csgorentla@gmail.com>
References: <1439035896-15213-1-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Inserted space between nested braces.  This fixes the checkpatch.pl
error - space required after that close brace '}'.

Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 3d12a44..3525145 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3331,7 +3331,7 @@ static int  WILC_WFI_add_station(struct wiphy *wiphy, struct net_device *dev,
 {
 	s32 s32Error = WILC_SUCCESS;
 	struct WILC_WFI_priv *priv;
-	tstrWILC_AddStaParam strStaParams = {{0}};
+	tstrWILC_AddStaParam strStaParams = { {0} };
 	perInterface_wlan_t *nic;
 
 
@@ -3462,7 +3462,7 @@ static int WILC_WFI_change_station(struct wiphy *wiphy, struct net_device *dev,
 {
 	s32 s32Error = WILC_SUCCESS;
 	struct WILC_WFI_priv *priv;
-	tstrWILC_AddStaParam strStaParams = {{0}};
+	tstrWILC_AddStaParam strStaParams = { {0} };
 	perInterface_wlan_t *nic;
 
 
-- 
2.5.0

