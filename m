Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:49483 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932950Ab3HGNSH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 09:18:07 -0400
Received: by mail-ee0-f44.google.com with SMTP id b47so841518eek.17
        for <linux-wireless@vger.kernel.org>; Wed, 07 Aug 2013 06:18:05 -0700 (PDT)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 2/2] ath10k: update supported FW build version
Date: Wed,  7 Aug 2013 15:17:46 +0200
Message-Id: <1375881466-30090-2-git-send-email-bartosz.markowski@tieto.com> (sfid-20130807_151816_217212_4512A934)
In-Reply-To: <1375881466-30090-1-git-send-email-bartosz.markowski@tieto.com>
References: <1375881466-30090-1-git-send-email-bartosz.markowski@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The latest supported and available FW build is 1.0.0.636.
Reflect this in ath10k code.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/hw.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 373c2ef..9868705 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -24,7 +24,7 @@
 #define SUPPORTED_FW_MAJOR	1
 #define SUPPORTED_FW_MINOR	0
 #define SUPPORTED_FW_RELEASE	0
-#define SUPPORTED_FW_BUILD	629
+#define SUPPORTED_FW_BUILD	636
 
 /* QCA988X 2.0 definitions */
 #define QCA988X_HW_2_0_VERSION		0x4100016c
-- 
1.7.9.5

