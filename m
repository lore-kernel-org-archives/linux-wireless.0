Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:45748 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932373AbeFLLjh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Jun 2018 07:39:37 -0400
Received: by mail-lf0-f68.google.com with SMTP id n3-v6so35484000lfe.12
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2018 04:39:37 -0700 (PDT)
From: Niklas Cassel <niklas.cassel@linaro.org>
To: Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: Niklas Cassel <niklas.cassel@linaro.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ath10k: do not mix spaces and tabs in Kconfig
Date: Tue, 12 Jun 2018 13:39:05 +0200
Message-Id: <20180612113907.15043-1-niklas.cassel@linaro.org> (sfid-20180612_133956_598770_235491BB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not mix spaces and tabs in Kconfig.

Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
---
 drivers/net/wireless/ath/ath10k/Kconfig | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/Kconfig b/drivers/net/wireless/ath/ath10k/Kconfig
index 84f071ac0d84..54ff5930126c 100644
--- a/drivers/net/wireless/ath/ath10k/Kconfig
+++ b/drivers/net/wireless/ath/ath10k/Kconfig
@@ -1,15 +1,15 @@
 config ATH10K
-        tristate "Atheros 802.11ac wireless cards support"
-        depends on MAC80211 && HAS_DMA
+	tristate "Atheros 802.11ac wireless cards support"
+	depends on MAC80211 && HAS_DMA
 	select ATH_COMMON
 	select CRC32
 	select WANT_DEV_COREDUMP
 	select ATH10K_CE
-        ---help---
-          This module adds support for wireless adapters based on
-          Atheros IEEE 802.11ac family of chipsets.
+	---help---
+	  This module adds support for wireless adapters based on
+	  Atheros IEEE 802.11ac family of chipsets.
 
-          If you choose to build a module, it'll be called ath10k.
+	  If you choose to build a module, it'll be called ath10k.
 
 config ATH10K_CE
 	bool
@@ -41,12 +41,12 @@ config ATH10K_USB
 	  work in progress and will not fully work.
 
 config ATH10K_SNOC
-        tristate "Qualcomm ath10k SNOC support (EXPERIMENTAL)"
-        depends on ATH10K && ARCH_QCOM
-        ---help---
-          This module adds support for integrated WCN3990 chip connected
-          to system NOC(SNOC). Currently work in progress and will not
-          fully work.
+	tristate "Qualcomm ath10k SNOC support (EXPERIMENTAL)"
+	depends on ATH10K && ARCH_QCOM
+	---help---
+	  This module adds support for integrated WCN3990 chip connected
+	  to system NOC(SNOC). Currently work in progress and will not
+	  fully work.
 
 config ATH10K_DEBUG
 	bool "Atheros ath10k debugging"
-- 
2.17.1
