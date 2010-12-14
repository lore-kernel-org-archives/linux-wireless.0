Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42967 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab0LNVpI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 16:45:08 -0500
Date: Tue, 14 Dec 2010 16:33:48 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Joe Perches <joe@perches.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Eduardo Costa <ecosta.tmp@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: another device working
Message-ID: <20101214213348.GD2389@tuxdriver.com>
References: <AANLkTimQQ5dbFjiZD993OGTHp8Qvb9+N6n4ZhGuG3HTQ@mail.gmail.com>
 <4D07D678.8030903@lwfinger.net>
 <1292361712.26726.31.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1292361712.26726.31.camel@Joe-Laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 14, 2010 at 01:21:52PM -0800, Joe Perches wrote:
> On Tue, 2010-12-14 at 14:41 -0600, Larry Finger wrote:
> > On 12/14/2010 11:09 AM, Eduardo Costa wrote:
> > >  {USB_DEVICE (0x15a9, 0x0002)},   /* Gemtek WUBI-100GW 802.11g */
> > > And about the firmware, it does work with stock p54's
> > > `2.13.24.0.lm87.arm' found on the website, so I just had to copy it to
> > > `/lib/firmware' while renaming it to `isl3887usb'.
> > Thanks for the report. I just submitted a patch to wireless-testing with a copy
> > to you for this change to be included in kernel 2.6.37, and to be backported to
> > all stable and long-term kernels.
> 
> Perhaps it'd be sensible to add a
> module_param option like usb_device=x,y
> so new devices could be supported without recompilation.

Isn't that what new_id is for?

At any rate, it isn't a great substitute for a device id in the driver's table. :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
