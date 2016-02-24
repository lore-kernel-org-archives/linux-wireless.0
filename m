Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34276 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbcBXTUF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 14:20:05 -0500
Received: by mail-pa0-f51.google.com with SMTP id fy10so17585611pac.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 11:20:05 -0800 (PST)
From: UJJAL ROY <royujjal@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	WiFi Mailing List <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] mwifiex: Added missing spaces around brackets
Date: Thu, 25 Feb 2016 00:49:56 +0530
Message-Id: <1456341596-517-1-git-send-email-royujjal@gmail.com> (sfid-20160224_202010_635992_EC572905)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the missing spaces issue in coding style.

Signed-off-by: UJJAL ROY <royujjal@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index e43aff9..0510861 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -244,9 +244,9 @@ setup_for_next:
 	if (card->rx_cmd_ep == context->ep) {
 		mwifiex_usb_submit_rx_urb(context, size);
 	} else {
-		if (atomic_read(&adapter->rx_pending) <= HIGH_RX_PENDING){
+		if (atomic_read(&adapter->rx_pending) <= HIGH_RX_PENDING) {
 			mwifiex_usb_submit_rx_urb(context, size);
-		}else{
+		} else {
 			context->skb = NULL;
 		}
 	}
--
1.9.1

