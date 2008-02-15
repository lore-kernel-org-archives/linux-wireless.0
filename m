Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc1-s38.bay0.hotmail.com ([65.54.246.110]:9960 "EHLO
	bay0-omc1-s38.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756949AbYBOVIG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 16:08:06 -0500
Message-ID: <BAY101-W378CC14C633084DBF091A6C8260@phx.gbl> (sfid-20080215_210813_053831_29057AF5)
From: Adam Turk <bofh1234@hotmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: <linux-wireless@vger.kernel.org>
Subject: RE: kernel 2.6.25-rc1 and no /dev/rt73usb
Date: Fri, 15 Feb 2008 16:08:04 -0500
In-Reply-To: <200802152146.06364.IvDoorn@gmail.com>
References: <BAY101-W101FB386E1EF7402881964C8260@phx.gbl>
 <20080215050358.GA10363@gondor.apana.org.au>
 <BAY101-W21A064889BC2442893B63BC8260@phx.gbl>
 <200802152146.06364.IvDoorn@gmail.com>
Content-Type: text/plain; charset=iso-8859-1
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> You are completely missing the point of the concept "modules",
> the module rt73usb is intended to support devices with the rt73 chips=
et.
>
> The rt73usb driver registers the device and creates an network interf=
ace
> inside the kernel. This interface is visible to you as user. The name=
 of this
> interface is wlan, depending on the number of wireless network cards =
in
> your system the interface number is attached to it so in your case wl=
an0.

Yep, I could be missing the concept of modules entirely. =20

The driver I was using before had the interface name of rt73.  When I s=
ee=20
usbcore: registered new interface driver rt73usb
I think the interface name is rt73usb.  Maybe change the line to read=20
usbcore: registered new interface driver rt73usb using name wlan0
so there is no confusing us newbies. =20

Thanks,

_________________________________________________________________
Need to know the score, the latest news, or you need your Hotmail=AE-ge=
t your "fix".
http://www.msnmobilefix.com/Default.aspx-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
