Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:31100 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbcBXKD0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 05:03:26 -0500
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <chris.park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 1/2] staging: wilc1000: wilc_wlan.c: remove unnecessary blank lines
Date: Wed, 24 Feb 2016 19:01:37 +0900
Message-ID: <1456308098-30049-1-git-send-email-tony.cho@atmel.com> (sfid-20160224_110337_695072_4D2F83C0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unnecessary blank lines found by checkpatch.pl.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index d50ddc6..f142e61 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -21,7 +21,6 @@ static inline void release_bus(struct wilc *wilc, BUS_RELEASE_T release)
 
 static void wilc_wlan_txq_remove(struct wilc *wilc, struct txq_entry_t *tqe)
 {
-
 	if (tqe == wilc->txq_head) {
 		wilc->txq_head = tqe->next;
 		if (wilc->txq_head)
@@ -248,7 +247,6 @@ static inline void tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 
 				add_tcp_pending_ack(ack_no, i, tqe);
 			}
-
 		}
 	}
 	spin_unlock_irqrestore(&wilc->txq_spinlock, flags);
@@ -429,7 +427,6 @@ static struct txq_entry_t *wilc_wlan_txq_get_next(struct wilc *wilc,
 
 static int wilc_wlan_rxq_add(struct wilc *wilc, struct rxq_entry_t *rqe)
 {
-
 	if (wilc->quit)
 		return 0;
 
@@ -450,7 +447,6 @@ static int wilc_wlan_rxq_add(struct wilc *wilc, struct rxq_entry_t *rqe)
 
 static struct rxq_entry_t *wilc_wlan_rxq_remove(struct wilc *wilc)
 {
-
 	if (wilc->rxq_head) {
 		struct rxq_entry_t *rqe;
 
-- 
1.9.1

