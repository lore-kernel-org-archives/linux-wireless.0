Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:31138 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbcBXKDc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 05:03:32 -0500
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <chris.park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 2/2] staging: wilc1000: wilc_wlan.c: remove multiple blank line
Date: Wed, 24 Feb 2016 19:01:38 +0900
Message-ID: <1456308098-30049-2-git-send-email-tony.cho@atmel.com> (sfid-20160224_110340_344664_78A9828B)
In-Reply-To: <1456308098-30049-1-git-send-email-tony.cho@atmel.com>
References: <1456308098-30049-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the multiple blank line reported by checkpatch.pl.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index f142e61..17e39cc 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -139,7 +139,6 @@ struct pending_acks_info {
 	struct txq_entry_t  *txqe;
 };
 
-
 #define NOT_TCP_ACK			(-1)
 
 #define MAX_TCP_SESSION		25
-- 
1.9.1

