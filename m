Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:46752 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753583AbeGFLD5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 07:03:57 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 01/12] mt76: add more states
Date: Fri,  6 Jul 2018 13:03:38 +0200
Message-Id: <1530875029-26274-2-git-send-email-sgruszka@redhat.com> (sfid-20180706_130401_350472_81012F12)
In-Reply-To: <1530875029-26274-1-git-send-email-sgruszka@redhat.com>
References: <1530875029-26274-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add states needed for mt76x0 driver.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 96e9798bb8a0..7b50d4b7f40e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -187,9 +187,13 @@ struct mt76_rx_tid {
 enum {
 	MT76_STATE_INITIALIZED,
 	MT76_STATE_RUNNING,
+	MT76_STATE_MCU_RUNNING,
 	MT76_SCANNING,
 	MT76_RESET,
 	MT76_OFFCHANNEL,
+	MT76_REMOVED,
+	MT76_READING_STATS,
+	MT76_MORE_STATS,
 };
 
 struct mt76_hw_cap {
-- 
1.9.3
