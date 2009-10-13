Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:60204 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488AbZJMIFx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 04:05:53 -0400
Received: by bwz6 with SMTP id 6so3683348bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2009 01:05:15 -0700 (PDT)
Message-ID: <4AD434B6.3090903@gmail.com>
Date: Tue, 13 Oct 2009 10:05:10 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com, IvDoorn@gmail.com
Subject: [PATCH] rt2800pci.c : more ids
Content-Type: multipart/mixed;
 boundary="------------070907000607080300050105"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070907000607080300050105
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

hi,

stolen from windows inf file(09/05/2009, 1.04.07.0000)

0x1814, 0x3060

-thanks-

regards,
-- 
«Allá muevan feroz guerra, ciegos reyes por un palmo más de tierra;
que yo aquí tengo por mío cuanto abarca el mar bravío, a quien nadie
impuso leyes. Y no hay playa, sea cualquiera, ni bandera de esplendor,
que no sienta mi derecho y dé pecho a mi valor.»

--------------070907000607080300050105
Content-Type: text/plain;
 name="new_id-2800pci.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="new_id-2800pci.diff"

diff -Nuar o/drivers/net/wireless/rt2800pci.c n/drivers/net/wireless/rt2800pci.c
--- o/drivers/net/wireless/rt2800pci.c	2009-10-13 09:57:37.523379731 +0200
+++ n/drivers/net/wireless/rt2800pci.c	2009-10-13 09:56:53.169379162 +0200
@@ -3237,6 +3237,7 @@
 	{ PCI_DEVICE(0x1814, 0x0681), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1814, 0x0701), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1814, 0x0781), PCI_DEVICE_DATA(&rt2800pci_ops) },
+	{ PCI_DEVICE(0x1814, 0x3060), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1814, 0x3062), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1814, 0x3090), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1814, 0x3091), PCI_DEVICE_DATA(&rt2800pci_ops) },

--------------070907000607080300050105--
