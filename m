Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:28801 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbYEPVxE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 17:53:04 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 2/2] orinoco_cs: add ID for SpeedStream wireless adapters
To: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 16 May 2008 17:53:03 -0400
Message-ID: <20080516215303.7176.52446.stgit@dv.roinet.com> (sfid-20080516_235308_229112_0F63741D)
In-Reply-To: <20080516215257.7176.59584.stgit@dv.roinet.com>
References: <20080516215257.7176.59584.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported by Gerald Willmann <gerald.willmann@econ.kuleuven.be>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/orinoco_cs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/orinoco_cs.c b/drivers/net/wireless/orinoco_cs.c
index 8b7f576..1c216e0 100644
--- a/drivers/net/wireless/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco_cs.c
@@ -461,6 +461,7 @@ static struct pcmcia_device_id orinoco_cs_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x028a, 0x0673), /* Linksys WCF12 Wireless CompactFlash Card */
 	PCMCIA_DEVICE_MANF_CARD(0x02aa, 0x0002), /* ASUS SpaceLink WL-100 */
 	PCMCIA_DEVICE_MANF_CARD(0x02ac, 0x0002), /* SpeedStream SS1021 Wireless Adapter */
+	PCMCIA_DEVICE_MANF_CARD(0x02ac, 0x3021), /* SpeedStream Wireless Adapter */
 	PCMCIA_DEVICE_MANF_CARD(0x14ea, 0xb001), /* PLANEX RoadLannerWave GW-NS11H */
 	PCMCIA_DEVICE_MANF_CARD(0x50c2, 0x7300), /* Airvast WN-100 */
 	PCMCIA_DEVICE_MANF_CARD(0x9005, 0x0021), /* Adaptec Ultra Wireless ANW-8030 */
