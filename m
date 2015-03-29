Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932622AbbC2NoL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2015 09:44:11 -0400
Date: Sun, 29 Mar 2015 15:43:26 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	netdev@vger.kernel.org
Subject: [PATCH 83/86] brcm80211: drop pci dependency
Message-ID: <1427635734-24786-84-git-send-email-mst@redhat.com> (sfid-20150329_154452_416062_3AA58FF8)
References: <1427635734-24786-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1427635734-24786-1-git-send-email-mst@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This file does not use any pci APIs, drop
pci header includes.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 227cb33..9331486 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -17,8 +17,6 @@
 
 #include <linux/types.h>
 #include <linux/netdevice.h>
-#include <linux/pci.h>
-#include <uapi/linux/pci_ids.h>
 #include <linux/sched.h>
 #include <linux/completion.h>
 #include <linux/scatterlist.h>
-- 
MST

