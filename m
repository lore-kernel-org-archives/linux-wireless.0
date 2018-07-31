Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:44080 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732093AbeGaOVm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 10:21:42 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v3 11/14] mt76: add more states
Date: Tue, 31 Jul 2018 14:41:01 +0200
Message-Id: <1533040864-9026-12-git-send-email-sgruszka@redhat.com> (sfid-20180731_144143_465206_764C3B2C)
In-Reply-To: <1533040864-9026-1-git-send-email-sgruszka@redhat.com>
References: <1533040864-9026-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add states needed for mt76x0 driver.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 4bf1b35ec44c..2eab35879163 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -204,11 +204,13 @@ struct mt76_rx_tid {
 enum {
 	MT76_STATE_INITIALIZED,
 	MT76_STATE_RUNNING,
+	MT76_STATE_MCU_RUNNING,
 	MT76_SCANNING,
 	MT76_RESET,
 	MT76_OFFCHANNEL,
 	MT76_REMOVED,
 	MT76_READING_STATS,
+	MT76_MORE_STATS,
 };
 
 struct mt76_hw_cap {
-- 
1.9.3
