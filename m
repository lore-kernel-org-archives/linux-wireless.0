Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:51707 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbZJSJ44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 05:56:56 -0400
Received: by ewy3 with SMTP id 3so3389555ewy.17
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2009 02:57:00 -0700 (PDT)
Message-ID: <4ADC3664.8050900@gmail.com>
Date: Mon, 19 Oct 2009 11:50:28 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com, IvDoorn@gmail.com
Subject: Re: [PATCH] rt2800pci.c : more ids
References: <4AD434B6.3090903@gmail.com>
In-Reply-To: <4AD434B6.3090903@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050802090007000706060501"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050802090007000706060501
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

On 10/13/2009 10:05 AM, Xose Vazquez Perez wrote:

> stolen from windows inf file(09/05/2009, 1.04.07.0000)
> 
> 0x1814, 0x3060

apply this one instead, 
got 0x1462,0x89a from linux driver(2009_0903_RT3090_Linux_STA_v2.2.0.1)

-thanks-

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

-- 
«Allá muevan feroz guerra, ciegos reyes por un palmo más de tierra;
que yo aquí tengo por mío cuanto abarca el mar bravío, a quien nadie
impuso leyes. Y no hay playa, sea cualquiera, ni bandera de esplendor,
que no sienta mi derecho y dé pecho a mi valor.»


--------------050802090007000706060501
Content-Type: text/plain;
 name="new_id-2800pci-v2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="new_id-2800pci-v2.diff"

--- o/drivers/net/wireless/rt2800pci.c	2009-10-13 09:57:37.523379731 +0200
+++ n/drivers/net/wireless/rt2800pci.c	2009-10-13 14:10:12.785378782 +0200
@@ -3225,6 +3225,8 @@
  * RT2800pci module information.
  */
 static struct pci_device_id rt2800pci_device_table[] = {
+	/* ??? */
+	{ PCI_DEVICE(0x1462, 0x891a), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	/* Edimax */
 	{ PCI_DEVICE(0x1432, 0x7708), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1432, 0x7727), PCI_DEVICE_DATA(&rt2800pci_ops) },
@@ -3233,10 +3235,12 @@
 	{ PCI_DEVICE(0x1432, 0x7748), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1432, 0x7758), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1432, 0x7768), PCI_DEVICE_DATA(&rt2800pci_ops) },
+	/* Ralink */
 	{ PCI_DEVICE(0x1814, 0x0601), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1814, 0x0681), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1814, 0x0701), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1814, 0x0781), PCI_DEVICE_DATA(&rt2800pci_ops) },
+	{ PCI_DEVICE(0x1814, 0x3060), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1814, 0x3062), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1814, 0x3090), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1814, 0x3091), PCI_DEVICE_DATA(&rt2800pci_ops) },


--------------050802090007000706060501--
