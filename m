Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:46351 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbZIOIGz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 04:06:55 -0400
Received: by ewy2 with SMTP id 2so217590ewy.17
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2009 01:06:58 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Fabian Lenz <lenz_fabian@yahoo.de>
Subject: Re: [RFC] ar9170usb: add ar9170 usbid
Date: Tue, 15 Sep 2009 10:06:26 +0200
Cc: linux-wireless@vger.kernel.org, Stephen.Chen@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
References: <200909142046.07525.lenz_fabian@yahoo.de> <200909142308.19569.chunkeey@googlemail.com> <200909150752.19146.lenz_fabian@yahoo.de>
In-Reply-To: <200909150752.19146.lenz_fabian@yahoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200909151006.26631.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 15 September 2009 07:52:19 Fabian Lenz wrote:
> Here the output of lsusb: 
> 
> Bus 002 Device 003: ID 0cf3:1002 Atheros Communications, Inc.

they made two revisions (v1 and v2).
Do you know which one you've got?

> and the product page of the WLAN stick:
> 
> http://www.tp-link.com/products/product_des.asp?id=140
> 
> I added { USB_DEVICE(0x0cf3, 0x1002) } to the usb.c file manually some time 
> ago and got my stick to work but the connection is somewhat unstable... but 
> that's another story.
what firmware image do you use?
the two-stage (ar9170-1.fw & ar9170-2.fw) firmware should work.
for one-stage you should use a bleeding edge wireless-testing tree.

Regards,
   Chr
