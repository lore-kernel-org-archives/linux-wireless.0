Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isp-bos-04.edutel.nl ([88.159.1.182]:33305 "EHLO
	isp-bos-04.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbbJRPR4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Oct 2015 11:17:56 -0400
Received: from isp-aos-01 (unknown [IPv6:2a01:670:100:11::1:1])
	by isp-bos-04.edutel.nl (Postfix) with ESMTPS id D66272E255C
	for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2015 17:17:52 +0200 (CEST)
Received: from [88.159.174.220] (helo=FransW7)
	by isp-aos-01 with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <fvdw@fvdw.eu>)
	id 1Znpia-0000ee-2u
	for linux-wireless@vger.kernel.org; Sun, 18 Oct 2015 17:17:52 +0200
Message-ID: <809DC09955974DA99BA61BF86298735F@FransW7> (sfid-20151018_171759_374255_C58B07BD)
From: "Frans van de Wiel" <fvdw@fvdw.eu>
To: <linux-wireless@vger.kernel.org>
Subject: Fw: patch for rtl8712 driver, add support for sitecom WLA2100 (006c)
Date: Sun, 18 Oct 2015 17:17:48 +0200
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0010_01D109C8.E981EB90"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dit is een meerdelig bericht in de MIME-indeling.

------=_NextPart_000_0010_01D109C8.E981EB90
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit



From: Frans van de Wiel
Sent: Sunday, October 18, 2015 4:34 PM
To: greg@kroah.com ; Larry.Finger@lwfinger.net ; 
florian.c.schilhabel@googlemail.com ; linux-wireless@vger.kernel.org
Subject: patch for rtl8712 driver, add support for sitecom WLA2100 (006c)

dear sirs, please find attached a patch for the rtl8712 driver (staging)
The patch add support for  sitecom WLA2100, seems this device id is missing. 
Many dongles use it.

Kind regards
Frans 

------=_NextPart_000_0010_01D109C8.E981EB90
Content-Type: application/octet-stream;
	name="patch.dat"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch.dat"

--- linux-3.14.2/drivers/staging/rtl8712/usb_intf.c.orig	2014-04-27 =
02:19:26.000000000 +0200=0A=
+++ linux-3.14.2/drivers/staging/rtl8712/usb_intf.c	2014-03-25 =
22:31:33.000000000 +0100=0A=
@@ -144,6 +144,7 @@ static struct usb_device_id rtl871x_usb_=0A=
 	{USB_DEVICE(0x0DF6, 0x0058)},=0A=
 	{USB_DEVICE(0x0DF6, 0x0049)},=0A=
 	{USB_DEVICE(0x0DF6, 0x004C)},=0A=
+	{USB_DEVICE(0x0DF6, 0x006C)},=0A=
 	{USB_DEVICE(0x0DF6, 0x0064)},=0A=
 	/* Skyworth */=0A=
 	{USB_DEVICE(0x14b2, 0x3300)},=0A=

------=_NextPart_000_0010_01D109C8.E981EB90--

