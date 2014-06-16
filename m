Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932400AbaFPR5i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 13:57:38 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Chen-Yu Tsai <wens@csie.org>, linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 3/4] brcmfmac: Fix some wrong register defines
Date: Mon, 16 Jun 2014 19:56:46 +0200
Message-Id: <1402941407-8210-4-git-send-email-hdegoede@redhat.com> (sfid-20140616_195744_986092_E27D8CF2)
In-Reply-To: <1402941407-8210-1-git-send-email-hdegoede@redhat.com>
References: <1402941407-8210-1-git-send-email-hdegoede@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 3deab79..6e6a366 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -72,12 +72,12 @@
 #define SBSDIO_SPROM_DATA_HIGH		0x10003
 /* sprom indirect access addr byte 0 */
 #define SBSDIO_SPROM_ADDR_LOW		0x10004
-/* sprom indirect access addr byte 0 */
-#define SBSDIO_SPROM_ADDR_HIGH		0x10005
-/* xtal_pu (gpio) output */
-#define SBSDIO_CHIP_CTRL_DATA		0x10006
-/* xtal_pu (gpio) enable */
-#define SBSDIO_CHIP_CTRL_EN		0x10007
+/* gpio select */
+#define SBSDIO_GPIO_SELECT		0x10005
+/* gpio output */
+#define SBSDIO_GPIO_OUT			0x10006
+/* gpio enable */
+#define SBSDIO_GPIO_EN			0x10007
 /* rev < 7, watermark for sdio device */
 #define SBSDIO_WATERMARK		0x10008
 /* control busy signal generation */
-- 
2.0.0

