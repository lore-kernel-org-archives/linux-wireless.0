Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:57311 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbXB1PuK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 10:50:10 -0500
Received: from hoboi3bl3.telenet-ops.be (hoboi3bl3.telenet-ops.be [195.130.137.86])
	by hoefnix.telenet-ops.be (Postfix) with ESMTP id 60F37A3ECC
	for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 16:49:52 +0100 (CET)
Received: from hoboe1bl1.telenet-ops.be (hoboe1bl1.telenet-ops.be [195.130.137.72])
	by hoboi3bl3.telenet-ops.be (8.13.1/8.13.1) with ESMTP id l1SFnqeD027471
	for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 16:49:52 +0100
Received: from [192.168.2.99] (dD576AE90.access.telenet.be [213.118.174.144])
	by hoboe1bl1.telenet-ops.be (Postfix) with ESMTP id E4D2BD404D
	for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 16:49:51 +0100 (CET)
Message-ID: <45E5A4C2.3090204@yahoo.co.uk>
Date: Wed, 28 Feb 2007 16:50:26 +0100
From: Ivo Couckuyt <iv0co@yahoo.co.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Patch: prism54usb, new device
Content-Type: multipart/mixed;
 boundary="------------090308020209090102040400"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090308020209090102040400
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Using islsm/prism54usb  succesfully with the Philips CPWUA054 device for 
a year now, made a little
patch for prism54usb
patched against

git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git


more info:
http://www.p4c.philips.com/cgi-bin/dcbint/cpindex.pl?ctn=CPWUA054/00&scy=BE&slg=NL&grp=PC_PRODUCTS_GR_BE_CONSUMER&cat=PC_NETWORKING_CA_BE_CONSUMER&sct=WIRELESS_ADAPTERS_SU_BE_CONSUMER

regards,
ilm



--------------090308020209090102040400
Content-Type: text/x-patch;
 name="prism54usb_cpwua.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="prism54usb_cpwua.patch"

--- islusb_init.c.old	2007-02-28 16:12:16.000000000 +0100
+++ islusb_init.c	2007-02-28 16:48:32.000000000 +0100
@@ -47,6 +47,7 @@
 	{USB_DEVICE(0x0707, 0xee06)},	/* SMC 2862W-G */
 	{USB_DEVICE(0x083a, 0x4501)},	/* Accton 802.11g WN4501 USB */
 	{USB_DEVICE(0x083a, 0x4502)},	/* Siemens Gigaset USB Adapter */
+	{USB_DEVICE(0x083a, 0x5501)},	/* Phillips CPWUA054*/  
 	{USB_DEVICE(0x0846, 0x4200)},	/* Netgear WG121 */
 	{USB_DEVICE(0x0846, 0x4210)},	/* Netgear WG121 the second ? */
 	{USB_DEVICE(0x0846, 0x4220)},	/* Netgear WG111 */

--------------090308020209090102040400--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
