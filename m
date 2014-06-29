Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbaF2ORh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2014 10:17:37 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Chen-Yu Tsai <wens@csie.org>, linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v3 3/4] brcmfmac: Fix some wrong register defines
Date: Sun, 29 Jun 2014 16:17:00 +0200
Message-Id: <1404051421-24377-4-git-send-email-hdegoede@redhat.com> (sfid-20140629_161742_162345_68EA6A61)
In-Reply-To: <1404051421-24377-1-git-send-email-hdegoede@redhat.com>
References: <1404051421-24377-1-git-send-email-hdegoede@redhat.com>
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

