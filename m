Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0073.outbound.protection.outlook.com ([104.47.42.73]:15232
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751122AbdHONGz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Aug 2017 09:06:55 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 1/9] qtnfmac: remove unused qtnf_rx_frame declaration
Date: Tue, 15 Aug 2017 16:06:31 +0300
Message-Id: <20170815130638.31718-2-sergey.matyukevich.os@quantenna.com> (sfid-20170815_150702_004723_E70C3395)
In-Reply-To: <20170815130638.31718-1-sergey.matyukevich.os@quantenna.com>
References: <20170815130638.31718-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/bus.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/bus.h b/drivers/net/wireless/quantenna/qtnfmac/bus.h
index dda05003d522..56e5fed92a2a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/bus.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/bus.h
@@ -130,7 +130,6 @@ static __always_inline void qtnf_bus_unlock(struct qtnf_bus *bus)
 
 /* interface functions from common layer */
 
-void qtnf_rx_frame(struct device *dev, struct sk_buff *rxp);
 int qtnf_core_attach(struct qtnf_bus *bus);
 void qtnf_core_detach(struct qtnf_bus *bus);
 void qtnf_txflowblock(struct device *dev, bool state);
-- 
2.11.0
