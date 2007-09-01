Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:63607 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbXIAEeo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:34:44 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id A55CC618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:34:43 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 05/35] Add myself to the author list
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:34:43 -0400
Message-ID: <20070901043443.2498.14904.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 0bb159d..967a0f0 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -5829,5 +5829,6 @@ MODULE_AUTHOR("Joerg Albert <joerg.albert@gmx.de>");
 MODULE_AUTHOR("Alex <alex@foogod.com>");
 MODULE_AUTHOR("Nick Jones");
 MODULE_AUTHOR("Balint Seeber <n0_5p4m_p13453@hotmail.com>");
+MODULE_AUTHOR("Pavel Roskin <proski@gnu.org>");
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
