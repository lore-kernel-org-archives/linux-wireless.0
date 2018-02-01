Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:39070 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754559AbeBABE3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 20:04:29 -0500
Received: by mail-pg0-f66.google.com with SMTP id w17so11537072pgv.6
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jan 2018 17:04:29 -0800 (PST)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [RFC v4 1/6] uapi: Add 802.11 Preauthentication to if_ether
Date: Wed, 31 Jan 2018 19:04:15 -0600
Message-Id: <20180201010420.6102-2-denkenz@gmail.com> (sfid-20180201_020433_861948_847AE78A)
In-Reply-To: <20180201010420.6102-1-denkenz@gmail.com>
References: <20180201010420.6102-1-denkenz@gmail.com>
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
