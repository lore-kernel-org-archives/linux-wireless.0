Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37778 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933521Ab2DSVdK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 17:33:10 -0400
Received: by mail-iy0-f174.google.com with SMTP id z16so12437635iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 14:33:09 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2/6 V2] rtlwifi: Add dm structs to private structure
Date: Thu, 19 Apr 2012 16:32:40 -0500
Message-Id: <1334871164-9795-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120419_233316_778652_CCA2BAF7)
In-Reply-To: <1334871164-9795-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1334871164-9795-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the dig_t and ps_t structures to the private variables.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/wifi.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 32df6bd..bd816ae 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -1688,6 +1688,10 @@ struct rtl_priv {
 	   interface or hardware */
 	unsigned long status;
 
+	/* tables for dm */
+	struct dig_t dm_digtable;
+	struct ps_t dm_pstable;
+
 	/* data buffer pointer for USB reads */
 	__le32 *usb_data;
 	int usb_data_index;
-- 
1.7.10.130.g36e6c

