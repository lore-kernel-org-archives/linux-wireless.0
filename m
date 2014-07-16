Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:39192 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbaGPVXp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 17:23:45 -0400
Received: by mail-we0-f179.google.com with SMTP id u57so1527148wes.24
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 14:23:44 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 21/21] staging: vt6656: Remove commented out long frequency_list
Date: Wed, 16 Jul 2014 22:22:11 +0100
Message-Id: <1405545731-6082-21-git-send-email-tvboxspy@gmail.com> (sfid-20140716_232357_393520_1DAC447D)
In-Reply-To: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
References: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These frequencies are already defined in new tables channel.c

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 932382f..6a46203 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -104,17 +104,6 @@ static struct usb_device_id vt6656_table[] = {
 	{}
 };
 
-/* frequency list (map channels to frequencies) */
-/*
-static const long frequency_list[] = {
-	2412, 2417, 2422, 2427, 2432, 2437, 2442, 2447, 2452, 2457, 2462, 2467,
-	2472, 2484, 4915, 4920, 4925, 4935, 4940, 4945, 4960, 4980, 5035, 5040,
-	5045, 5055, 5060, 5080, 5170, 5180, 5190, 5200, 5210, 5220, 5230, 5240,
-	5260, 5280, 5300, 5320, 5500, 5520, 5540, 5560, 5580, 5600, 5620, 5640,
-	5660, 5680, 5700, 5745, 5765, 5785, 5805, 5825
-};
-*/
-
 static void device_set_options(struct vnt_private *priv)
 {
 	/* Set number of TX buffers */
-- 
2.0.1

