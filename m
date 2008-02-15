Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4055 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbYBOVJZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 16:09:25 -0500
Date: Fri, 15 Feb 2008 15:33:59 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Adam Turk <bofh1234@hotmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-wireless@vger.kernel.org
Subject: Re: kernel 2.6.25-rc1 and no /dev/rt73usb
Message-ID: <20080215203359.GB3054@tuxdriver.com> (sfid-20080215_210930_676838_0C0DCFD0)
References: <BAY101-W101FB386E1EF7402881964C8260@phx.gbl> <20080215050358.GA10363@gondor.apana.org.au> <BAY101-W21A064889BC2442893B63BC8260@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BAY101-W21A064889BC2442893B63BC8260@phx.gbl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 15, 2008 at 03:27:51PM -0500, Adam Turk wrote:
> 
> > You need to enable KMOD. Otherwise you must manually preload
> > the relevant modules.
> 
> I thought that was what udev was for?  Anyway I recompiled with KMOD enabled and I have partial success.  I nolonger get any errors when I plug in my wireless card.  
> dmesg says:
> usbcore: registered new interface driver rt73usb
> 
> I do a ifconfig rt73usb up and I get a device not found.
> I do a ifconfig -a and see the card is called wlan0 and wmaster0.
> So there is a disparity having somewhere.  wlan0 or rt73usb?  Which is it?

wlan0

-- 
John W. Linville
linville@tuxdriver.com
