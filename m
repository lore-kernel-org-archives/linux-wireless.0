Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:53490 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbaGTOej (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:34:39 -0400
Received: by mail-wi0-f169.google.com with SMTP id n3so3093606wiv.4
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 07:34:38 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 12/25] staging: vt6656: struct vnt_private remove dead variable bBarkerPreambleMd
Date: Sun, 20 Jul 2014 15:33:22 +0100
Message-Id: <1405866815-2687-12-git-send-email-tvboxspy@gmail.com> (sfid-20140720_165108_039732_BB2F87A7)
In-Reply-To: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
References: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 35bc8c6..905e90b 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -359,7 +359,6 @@ struct vnt_private {
 	enum nl80211_iftype op_mode;
 
 	int short_slot_time;
-	int bBarkerPreambleMd;
 
 	/* Power save */
 	u16 current_aid;
-- 
2.0.1

