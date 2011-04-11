Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60020 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab1DKSA0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 14:00:26 -0400
Date: Mon, 11 Apr 2011 13:58:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH] rt2800usb: Add three new USB IDs
Message-ID: <20110411175810.GB2511@tuxdriver.com>
References: <4DA1E4ED.6080804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4DA1E4ED.6080804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 10, 2011 at 07:12:13PM +0200, Xose Vazquez Perez wrote:
> Larry Finger wrote:
> 
> > There are three USB IDs supported by staging/rt2870sta that are not in the
> > mainline driver rt2800usb.
> > 
> > Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> > Cc: Stable <stable@vger.kernel.org>
> > ---
> > 
> > Index: wireless-testing/drivers/net/wireless/rt2x00/rt2800usb.c
> > ===================================================================
> > --- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2800usb.c
> > +++ wireless-testing/drivers/net/wireless/rt2x00/rt2800usb.c
> > @@ -758,6 +758,8 @@ static struct usb_device_id rt2800usb_de
> >  	{ USB_DEVICE(0x07d1, 0x3c0f), USB_DEVICE_DATA(&rt2800usb_ops) },
> >  	{ USB_DEVICE(0x07d1, 0x3c11), USB_DEVICE_DATA(&rt2800usb_ops) },
> >  	{ USB_DEVICE(0x07d1, 0x3c16), USB_DEVICE_DATA(&rt2800usb_ops) },
> > +	{ USB_DEVICE(0x2001, 0x3c09), USB_DEVICE_DATA(&rt2800usb_ops) },
> > +	{ USB_DEVICE(0x2001, 0x3c0a), USB_DEVICE_DATA(&rt2800usb_ops) },
> >  	/* Draytek */
> >  	{ USB_DEVICE(0x07fa, 0x7712), USB_DEVICE_DATA(&rt2800usb_ops) },
> >  	/* Edimax */
> > @@ -828,6 +830,7 @@ static struct usb_device_id rt2800usb_de
> >  	/* Planex */
> >  	{ USB_DEVICE(0x2019, 0xab25), USB_DEVICE_DATA(&rt2800usb_ops) },
> >  	{ USB_DEVICE(0x2019, 0xed06), USB_DEVICE_DATA(&rt2800usb_ops) },
> > +	{ USB_DEVICE(0x2019, 0xed14), USB_DEVICE_DATA(&rt2800usb_ops) },
> >  	/* Quanta */
> >  	{ USB_DEVICE(0x1a32, 0x0304), USB_DEVICE_DATA(&rt2800usb_ops) },
> >  	/* Ralink */
> 
> NACK, unless they also be in the windows driver.
> They were eliminated in recent versions of ralink LiNUX drivers.

OK, I already had this merged since Ivo and Gertjan had ACKed it.

I need to rebase wireless-2.6 anyway, so I'll drop this one too
for now.  Please come to a consensus on whether or not these should
be included and let me know...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
