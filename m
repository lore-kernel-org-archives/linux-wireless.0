Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:15910 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbZAIRbu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 12:31:50 -0500
Subject: [PATCH] orinoco_cs: add ID for ARtem Onair Comcard 11
To: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Cc: Michael Jarosch <mitsch@riotmusic.de>
Date: Fri, 09 Jan 2009 12:31:48 -0500
Message-ID: <20090109173148.28547.22079.stgit@dv.roinet.com> (sfid-20090109_183155_558402_550084EC)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported by Michael Jarosch <mitsch@riotmusic.de>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/orinoco/orinoco_cs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco_cs.c b/drivers/net/wireless/orinoco/orinoco_cs.c
index 14ff274..59ad536 100644
--- a/drivers/net/wireless/orinoco/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco/orinoco_cs.c
@@ -435,6 +435,7 @@ static struct pcmcia_device_id orinoco_cs_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x0250, 0x0002), /* Samsung SWL2000-N 11Mb/s WLAN Card */
 	PCMCIA_DEVICE_MANF_CARD(0x0261, 0x0002), /* AirWay 802.11 Adapter (PCMCIA) */
 	PCMCIA_DEVICE_MANF_CARD(0x0268, 0x0001), /* ARtem Onair */
+	PCMCIA_DEVICE_MANF_CARD(0x0268, 0x0003), /* ARtem Onair Comcard 11 */
 	PCMCIA_DEVICE_MANF_CARD(0x026f, 0x0305), /* Buffalo WLI-PCM-S11 */
 	PCMCIA_DEVICE_MANF_CARD(0x0274, 0x1612), /* Linksys WPC11 Version 2.5 */
 	PCMCIA_DEVICE_MANF_CARD(0x0274, 0x1613), /* Linksys WPC11 Version 3 */
