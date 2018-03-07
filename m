Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:38784 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934924AbeCHPLL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 10:11:11 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 06/10] staging: wilc1000: fix line over 80 char in get_key() & set_default_key()
Date: Wed, 7 Mar 2018 07:02:26 +0530
Message-ID: <1520386350-31607-7-git-send-email-ajay.kathat@microchip.com> (sfid-20180308_161117_673453_A075D362)
In-Reply-To: <1520386350-31607-1-git-send-email-ajay.kathat@microchip.com>
References: <1520386350-31607-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'line over 80 characters' issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 3354bf2..92c3213 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1118,8 +1118,8 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 }
 
 static int get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
-		   bool pairwise,
-		   const u8 *mac_addr, void *cookie, void (*callback)(void *cookie, struct key_params *))
+		   bool pairwise, const u8 *mac_addr, void *cookie,
+		   void (*callback)(void *cookie, struct key_params *))
 {
 	struct wilc_priv *priv;
 	struct  key_params key_params;
@@ -1145,8 +1145,8 @@ static int get_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 	return 0;
 }
 
-static int set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
-			   bool unicast, bool multicast)
+static int set_default_key(struct wiphy *wiphy, struct net_device *netdev,
+			   u8 key_index, bool unicast, bool multicast)
 {
 	struct wilc_priv *priv;
 	struct wilc_vif *vif;
-- 
2.7.4
