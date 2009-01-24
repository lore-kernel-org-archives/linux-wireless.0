Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55041 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbZAXOPR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 09:15:17 -0500
Subject: [PATCH 7/7 v2] airo: remove useless #defines
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1232748914.447.2.camel@localhost.localdomain>
References: <1232748914.447.2.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 24 Jan 2009 09:13:58 -0500
Message-Id: <1232806438.2870.12.camel@localhost.localdomain> (sfid-20090124_151520_926526_7C0D08F0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index c047580..acda458 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -1094,12 +1094,6 @@ typedef struct wep_key_t {
 	u8	key[16];	/* 40-bit and 104-bit keys */
 } wep_key_t;
 
-/* Backward compatibility */
-#ifndef IW_ENCODE_NOKEY
-#define IW_ENCODE_NOKEY         0x0800  /* Key is write only, so not present */
-#define IW_ENCODE_MODE  (IW_ENCODE_DISABLED | IW_ENCODE_RESTRICTED | IW_ENCODE_OPEN)
-#endif /* IW_ENCODE_NOKEY */
-
 /* List of Wireless Handlers (new API) */
 static const struct iw_handler_def	airo_handler_def;
 

