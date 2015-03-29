Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833AbbC2Nng (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2015 09:43:36 -0400
Date: Sun, 29 Mar 2015 15:43:31 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Daniel Kim <dekim@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	netdev@vger.kernel.org
Subject: [PATCH 84/86] brcm80211: drop pci_ids include
Message-ID: <1427635734-24786-85-git-send-email-mst@redhat.com> (sfid-20150329_154532_799379_9BC25B61)
References: <1427635734-24786-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1427635734-24786-1-git-send-email-mst@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This file does not use any pci ids, drop
pci_ids.h include.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index 5c4755d..da479d4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -18,7 +18,6 @@
 #include <linux/kernel.h>
 #include <linux/kthread.h>
 #include <linux/printk.h>
-#include <uapi/linux/pci_ids.h>
 #include <linux/netdevice.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
-- 
MST

