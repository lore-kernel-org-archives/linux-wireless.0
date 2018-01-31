Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:45584 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751782AbeAaVdk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 16:33:40 -0500
Received: by mail-pg0-f67.google.com with SMTP id m136so11115445pga.12
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jan 2018 13:33:40 -0800 (PST)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH 1/6] uapi: Add 802.11 Preauthentication to if_ether
Date: Wed, 31 Jan 2018 15:33:24 -0600
Message-Id: <20180131213329.25322-2-denkenz@gmail.com> (sfid-20180131_223345_248960_F48E98FD)
In-Reply-To: <20180131213329.25322-1-denkenz@gmail.com>
References: <20180131213329.25322-1-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds 0x88c7 protocol type to if_ether.

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 include/uapi/linux/if_ether.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
index f8cb5760ea4f..54585906e50a 100644
--- a/include/uapi/linux/if_ether.h
+++ b/include/uapi/linux/if_ether.h
@@ -89,6 +89,7 @@
 #define ETH_P_AOE	0x88A2		/* ATA over Ethernet		*/
 #define ETH_P_8021AD	0x88A8          /* 802.1ad Service VLAN		*/
 #define ETH_P_802_EX1	0x88B5		/* 802.1 Local Experimental 1.  */
+#define ETH_P_PREAUTH	0x88C7		/* 802.11 Preauthentication */
 #define ETH_P_TIPC	0x88CA		/* TIPC 			*/
 #define ETH_P_MACSEC	0x88E5		/* 802.1ae MACsec */
 #define ETH_P_8021AH	0x88E7          /* 802.1ah Backbone Service Tag */
-- 
2.13.5
