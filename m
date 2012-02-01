Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756415Ab2BAPSI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 10:18:08 -0500
Date: Wed, 1 Feb 2012 16:17:40 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 5/4] rt2800: document RF_R03 register bits [7:4]
Message-ID: <20120201151739.GD10045@redhat.com> (sfid-20120201_161813_024137_0C0A9572)
References: <1327936679-12576-1-git-send-email-sgruszka@redhat.com>
 <1327936679-12576-4-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1327936679-12576-4-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Taken from:
2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO
(based on function RT33xx_ChipSwitchChannel)

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index c92fb2e..fac9ece 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1799,6 +1799,9 @@ struct mac_iveiv_entry {
  * RFCSR 3:
  */
 #define RFCSR3_K			FIELD8(0x0f)
+/* Bits [7-4] for RF3320 (RT3370/RT3390), on other chipsets reserved */
+#define RFCSR3_PA1_BIAS_CCK		FIELD8(0x70);
+#define RFCSR3_PA2_CASCODE_BIAS_CCKK	FIELD8(0x80);
 
 /*
  * FRCSR 5:
-- 
1.7.1

