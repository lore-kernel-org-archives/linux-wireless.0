Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:2657 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760000Ab0LNVVx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 16:21:53 -0500
Subject: Re: another device working
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Eduardo Costa <ecosta.tmp@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4D07D678.8030903@lwfinger.net>
References: <AANLkTimQQ5dbFjiZD993OGTHp8Qvb9+N6n4ZhGuG3HTQ@mail.gmail.com>
	 <4D07D678.8030903@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Dec 2010 13:21:52 -0800
Message-ID: <1292361712.26726.31.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-14 at 14:41 -0600, Larry Finger wrote:
> On 12/14/2010 11:09 AM, Eduardo Costa wrote:
> >  {USB_DEVICE (0x15a9, 0x0002)},   /* Gemtek WUBI-100GW 802.11g */
> > And about the firmware, it does work with stock p54's
> > `2.13.24.0.lm87.arm' found on the website, so I just had to copy it to
> > `/lib/firmware' while renaming it to `isl3887usb'.
> Thanks for the report. I just submitted a patch to wireless-testing with a copy
> to you for this change to be included in kernel 2.6.37, and to be backported to
> all stable and long-term kernels.

Perhaps it'd be sensible to add a
module_param option like usb_device=x,y
so new devices could be supported without recompilation.

