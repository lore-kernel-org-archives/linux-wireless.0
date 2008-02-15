Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc3-s9.bay0.hotmail.com ([65.54.246.209]:54011 "EHLO
	bay0-omc3-s9.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755788AbYBOU1w convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 15:27:52 -0500
Message-ID: <BAY101-W21A064889BC2442893B63BC8260@phx.gbl> (sfid-20080215_202755_355768_FCB15D21)
From: Adam Turk <bofh1234@hotmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-wireless@vger.kernel.org>
Subject: RE: kernel 2.6.25-rc1 and no /dev/rt73usb
Date: Fri, 15 Feb 2008 15:27:51 -0500
In-Reply-To: <20080215050358.GA10363@gondor.apana.org.au>
References: <BAY101-W101FB386E1EF7402881964C8260@phx.gbl>
 <20080215050358.GA10363@gondor.apana.org.au>
Content-Type: text/plain; charset=iso-8859-1
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> You need to enable KMOD. Otherwise you must manually preload
> the relevant modules.

I thought that was what udev was for?  Anyway I recompiled with KMOD en=
abled and I have partial success.  I nolonger get any errors when I plu=
g in my wireless card. =20
dmesg says:
usbcore: registered new interface driver rt73usb

I do a ifconfig rt73usb up and I get a device not found.
I do a ifconfig -a and see the card is called wlan0 and wmaster0.
So there is a disparity having somewhere.  wlan0 or rt73usb?  Which is =
it?

Thanks,
 =20
_________________________________________________________________
Need to know the score, the latest news, or you need your Hotmail=AE-ge=
t your "fix".
http://www.msnmobilefix.com/Default.aspx-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
