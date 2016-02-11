Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:32953 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbcBKGrU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2016 01:47:20 -0500
Received: by mail-pf0-f193.google.com with SMTP id c10so2103247pfc.0
        for <linux-wireless@vger.kernel.org>; Wed, 10 Feb 2016 22:47:19 -0800 (PST)
From: Ujjal Roy <royujjal@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	WiFi Mailing List <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] mwifiex: Added missing spaces around brackets
Date: Thu, 11 Feb 2016 12:17:09 +0530
Message-Id: <1455173229-6383-3-git-send-email-royujjal@gmail.com> (sfid-20160211_074726_748090_C24263AD)
In-Reply-To: <1455173229-6383-1-git-send-email-royujjal@gmail.com>
References: <1455173229-6383-1-git-send-email-royujjal@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the missing spaces issue in coding style.

Signed-off-by: Ujjal Roy <royujjal@gmail.com>
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

