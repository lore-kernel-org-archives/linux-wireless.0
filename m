Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:54450 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732086AbeGaOVr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 10:21:47 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v3 14/14] mt76x0: load firmware from mediatek subdir
Date: Tue, 31 Jul 2018 14:41:04 +0200
Message-Id: <1533040864-9026-15-git-send-email-sgruszka@redhat.com> (sfid-20180731_144145_299964_8A643CFD)
In-Reply-To: <1533040864-9026-1-git-send-email-sgruszka@redhat.com>
References: <1533040864-9026-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware blob will be located in mediatek subdirectory. Add "u" suffix
to indicate this is USB device firmware.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.h b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.h
index 9e42dfa665de..492e431390a8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.h
@@ -16,7 +16,7 @@
 
 #include "mt76x0.h"
 
-#define MT7610_FIRMWARE	"mt7610.bin"
+#define MT7610_FIRMWARE	"mediatek/mt7610u.bin"
 
 #define MT_VEND_REQ_MAX_RETRY	10
 #define MT_VEND_REQ_TOUT_MS	300
-- 
1.9.3
