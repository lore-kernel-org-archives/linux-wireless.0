Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:28801 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbYEPVw7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 17:52:59 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 1/2] hostap_cs: add ID for Conceptronic CON11CPro
To: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 16 May 2008 17:52:57 -0400
Message-ID: <20080516215257.7176.59584.stgit@dv.roinet.com> (sfid-20080516_235306_588050_5A6A1116)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported by Santiago Garcia Mantinan <hostap@manty.net>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/hostap/hostap_cs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index 437a9bc..ed4317a 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -833,6 +833,7 @@ static struct pcmcia_device_id hostap_cs_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x50c2, 0x0001),
 	PCMCIA_DEVICE_MANF_CARD(0x50c2, 0x7300),
 /*	PCMCIA_DEVICE_MANF_CARD(0xc00f, 0x0000),    conflict with pcnet_cs */
+	PCMCIA_DEVICE_MANF_CARD(0xc250, 0x0002),
 	PCMCIA_DEVICE_MANF_CARD(0xd601, 0x0002),
 	PCMCIA_DEVICE_MANF_CARD(0xd601, 0x0005),
 	PCMCIA_DEVICE_MANF_CARD(0xd601, 0x0010),
