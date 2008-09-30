Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:16013 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbYI3R4o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 13:56:44 -0400
Received: by ey-out-2122.google.com with SMTP id 6so57904eyi.37
        for <linux-wireless@vger.kernel.org>; Tue, 30 Sep 2008 10:56:42 -0700 (PDT)
Date: Tue, 30 Sep 2008 19:56:34 +0200
From: Davide Pesavento <davidepesa@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wireless: fix typo in Kconfig.
Message-ID: <20080930175634.GA16577@PesaBook.pesa.homelinux.org> (sfid-20080930_195657_091197_60979494)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Davide Pesavento <davidepesa@gmail.com>

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index b97bd9f..7d82be0 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -15,7 +15,7 @@ config NL80211
 	  If unsure, say Y.
 
 config WIRELESS_OLD_REGULATORY
-	bool "Old wireless static regulatory defintions"
+	bool "Old wireless static regulatory definitions"
 	default n
 	---help---
 	  This option enables the old static regulatory information
-- 
1.6.0.2

