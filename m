Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47224 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527Ab2EOOJU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 10:09:20 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so5822694wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 07:09:19 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Assaf Azulay <assaf@ti.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 08/10] wlcore: increase number of BA sessions to 3
Date: Tue, 15 May 2012 17:08:58 +0300
Message-Id: <1337090940-13750-8-git-send-email-arik@wizery.com> (sfid-20120515_160932_133196_802A5F1D)
In-Reply-To: <1337090940-13750-1-git-send-email-arik@wizery.com>
References: <1337090940-13750-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Azulay <assaf@ti.com>

With the new FW (sigle role X.3.8.0.108, multi role X.5.4.0.21)
we are supporting 3 RX BA sessions, this change is to support this
new ability.

Signed-off-by: Assaf Azulay <assaf@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/acx.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/acx.h b/drivers/net/wireless/ti/wlcore/acx.h
index 28fb35c..26a5dc3 100644
--- a/drivers/net/wireless/ti/wlcore/acx.h
+++ b/drivers/net/wireless/ti/wlcore/acx.h
@@ -726,7 +726,7 @@ struct wl1271_acx_ht_information {
 	u8 padding[2];
 } __packed;
 
-#define RX_BA_MAX_SESSIONS 2
+#define RX_BA_MAX_SESSIONS 3
 
 struct wl1271_acx_ba_initiator_policy {
 	struct acx_header header;
-- 
1.7.9.5

