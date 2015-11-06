Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36516 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031107AbbKFCLP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:11:15 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 08/73] staging: wilc1000: fixes missing a blank line after declarations
Date: Fri, 6 Nov 2015 11:12:29 +0900
Message-ID: <1446776014-28094-8-git-send-email-glen.lee@atmel.com> (sfid-20151106_031118_163309_9D7D172C)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the warnings reported by checkpatch.pl
for Missing a blank line after declarations.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index d3117f9..7ebfcaf 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -81,6 +81,7 @@ static inline void release_bus(BUS_RELEASE_T release)
 static void wilc_wlan_txq_remove(struct txq_entry_t *tqe)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
+
 	if (tqe == p->txq_head)	{
 		p->txq_head = tqe->next;
 		if (p->txq_head)
@@ -500,6 +501,7 @@ static struct txq_entry_t *wilc_wlan_txq_get_next(struct wilc *wilc,
 						  struct txq_entry_t *tqe)
 {
 	unsigned long flags;
+
 	spin_lock_irqsave(&wilc->txq_spinlock, flags);
 
 	tqe = tqe->next;
-- 
1.9.1

