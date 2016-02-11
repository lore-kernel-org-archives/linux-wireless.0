Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:35438 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbcBKGrR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2016 01:47:17 -0500
Received: by mail-pa0-f68.google.com with SMTP id fl4so2008428pad.2
        for <linux-wireless@vger.kernel.org>; Wed, 10 Feb 2016 22:47:17 -0800 (PST)
From: Ujjal Roy <royujjal@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	WiFi Mailing List <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] mwifiex: Removed extra spaces before commas
Date: Thu, 11 Feb 2016 12:17:08 +0530
Message-Id: <1455173229-6383-2-git-send-email-royujjal@gmail.com> (sfid-20160211_074726_144729_D697F3E2)
In-Reply-To: <1455173229-6383-1-git-send-email-royujjal@gmail.com>
References: <1455173229-6383-1-git-send-email-royujjal@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes spaces before commas issue in coding style.

Signed-off-by: Ujjal Roy <royujjal@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c    | 2 +-
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 6d0dc40..4d29cce 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -1408,7 +1408,7 @@ mwifiex_pcie_send_boot_cmd(struct mwifiex_adapter *adapter, struct sk_buff *skb)
 		return -1;
 	}

-	if (mwifiex_map_pci_memory(adapter, skb, skb->len , PCI_DMA_TODEVICE))
+	if (mwifiex_map_pci_memory(adapter, skb, skb->len, PCI_DMA_TODEVICE))
 		return -1;

 	buf_pa = MWIFIEX_SKB_DMA_ADDR(skb);
diff --git a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
index e791166..16d95b2 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
@@ -192,7 +192,7 @@ mwifiex_set_ht_params(struct mwifiex_private *priv,
 		}
 		priv->ap_11n_enabled = 1;
 	} else {
-		memset(&bss_cfg->ht_cap , 0, sizeof(struct ieee80211_ht_cap));
+		memset(&bss_cfg->ht_cap, 0, sizeof(struct ieee80211_ht_cap));
 		bss_cfg->ht_cap.cap_info = cpu_to_le16(MWIFIEX_DEF_HT_CAP);
 		bss_cfg->ht_cap.ampdu_params_info = MWIFIEX_DEF_AMPDU;
 	}
--
1.9.1

