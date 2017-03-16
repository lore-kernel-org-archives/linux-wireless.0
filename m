Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:34590 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752285AbdCPVv0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 17:51:26 -0400
Received: by mail-qk0-f196.google.com with SMTP id v127so7731996qkb.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Mar 2017 14:51:20 -0700 (PDT)
Date: Thu, 16 Mar 2017 17:51:12 -0400
From: Dylan Leggio <dleggio1@binghamton.edu>
To: aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: wilc1000: fix two typos in #define's
Message-ID: <20170316215112.GA2427@legs> (sfid-20170316_225152_057674_21FDB111)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Dylan Leggio <dleggio1@binghamton.edu>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index a37896fcd683..1bb63702c623 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -29,8 +29,8 @@
 #define P2P_INV_REQ			0x03
 #define P2P_INV_RSP			0x04
 #define PUBLIC_ACT_VENDORSPEC		0x09
-#define GAS_INTIAL_REQ			0x0a
-#define GAS_INTIAL_RSP			0x0b
+#define GAS_INITIAL_REQ			0x0a
+#define GAS_INITIAL_RSP			0x0b
 
 #define INVALID_CHANNEL			0
 
@@ -1477,10 +1477,10 @@ void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size)
 			}
 			if (buff[ACTION_CAT_ID] == PUB_ACTION_ATTR_ID) {
 				switch (buff[ACTION_SUBTYPE_ID]) {
-				case GAS_INTIAL_REQ:
+				case GAS_INITIAL_REQ:
 					break;
 
-				case GAS_INTIAL_RSP:
+				case GAS_INITIAL_RSP:
 					break;
 
 				case PUBLIC_ACT_VENDORSPEC:
@@ -1666,10 +1666,10 @@ static int mgmt_tx(struct wiphy *wiphy,
 					curr_channel = chan->hw_value;
 				}
 				switch (buf[ACTION_SUBTYPE_ID])	{
-				case GAS_INTIAL_REQ:
+				case GAS_INITIAL_REQ:
 					break;
 
-				case GAS_INTIAL_RSP:
+				case GAS_INITIAL_RSP:
 					break;
 
 				case PUBLIC_ACT_VENDORSPEC:
-- 
2.12.0
