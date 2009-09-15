Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:3116 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbZIONQy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 09:16:54 -0400
Received: by ey-out-2122.google.com with SMTP id 25so783182eya.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2009 06:16:57 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
Subject: Re: [RFC] ar9170usb: add ar9170 usbid
Date: Tue, 15 Sep 2009 15:16:50 +0200
Cc: Fabian Lenz <lenz_fabian@yahoo.de>, linux-wireless@vger.kernel.org,
	Stephen.Chen@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
References: <200909142046.07525.lenz_fabian@yahoo.de> <200909151006.26631.chunkeey@googlemail.com> <200909151337.15163.s.L-H@gmx.de>
In-Reply-To: <200909151337.15163.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200909151516.50537.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 15 September 2009 13:37:13 Stefan Lippers-Hollmann wrote:
> On Tuesday 15 September 2009, Christian Lamparter wrote:
> > On Tuesday 15 September 2009 07:52:19 Fabian Lenz wrote:
> > > Here the output of lsusb: 
> > > 
> > > Bus 002 Device 003: ID 0cf3:1002 Atheros Communications, Inc.
> > 
> > they made two revisions (v1 and v2).
> > Do you know which one you've got?
> 
> v1 (FCC ID: TE7WN821NV1) at least identifies itself as:
> ID 0cf3:9170 Atheros Communications, Inc. AR9170 802.11n
thanks! so, they sticked with the correct id for v1.

> > > and the product page of the WLAN stick:
> > > 
> > > http://www.tp-link.com/products/product_des.asp?id=140
> > > 
> > > I added { USB_DEVICE(0x0cf3, 0x1002) } to the usb.c file manually some time 
> > > ago and got my stick to work but the connection is somewhat unstable... but 
> > > that's another story.
> > what firmware image do you use?
> > the two-stage (ar9170-1.fw & ar9170-2.fw) firmware should work.
> > for one-stage you should use a bleeding edge wireless-testing tree.
> 
> On this TL-WN821N v1 the one-stage (as published in binary from by Atheros,
> so far I had problems with my self compiled one) and two-stage firmwares 
> work equally well on a vanilla 2.6.31 kernel:
the catch here is that some devices won't work with the
two-stage firmware (e.g: AVM FRITZ!WLAN USB Stick N 2.4 )

That's why the delay.

Regards,
	Chr 
