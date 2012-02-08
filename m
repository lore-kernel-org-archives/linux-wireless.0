Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr8.hinet.net ([168.95.4.108]:62708 "EHLO msr8.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756410Ab2BHB6t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 20:58:49 -0500
Date: Wed, 8 Feb 2012 09:58:25 +0800
From: Ali Bahar <ali@internetdog.org>
To: dganic@bmail.ru
Cc: wlanfae@realtek.com, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: drivers realtek rtl8191su [rtl8712 ]
Message-ID: <20120208015824.GA6145@internetdog.org> (sfid-20120208_025853_090840_8CEFA3B8)
Reply-To: ali@internetdog.org
References: <web-16212948@mail-be01.sovam.com>
 <20120207020837.GA29465@internetdog.org>
 <web-10842365@mail-be03.sovam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <web-10842365@mail-be03.sovam.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alexander,


On Tue, Feb 07, 2012 at 07:53:44PM +0300, dganic@bmail.ru wrote:
> Thank you Ali for your reply email. One can wonder why you continue
> to develop this driver, and still the most interesting place: (Maybe

as you have figured out by now, Larry Finger is the main guy for this
driver, not me. I just submitted a few patches this past summer.


> you can help me by passing this information in any other developer
> in a position to write the full realization of this driver? The
> average user like me, they are unlikely to be listen, and you as the
> developer will have to listen. Perhaps you have the opportunity to
> publish this information in the Linux kernel mailing list or
> linuxdrivers.org? or have any contacts who can I turn? itself does

Larry and the linux-wireless list were CCed in my original reply. When
you have issues, you can directly email the list yourself.

take care,
ali



> not implement realtek drivers for their devices under Linux?
> 
> with respect, Alexander Anishchenko
> 
> On Tue, 7 Feb 2012 10:08:37 +0800
>  Ali Bahar <ali@internetdog.org> wrote:
>  Hi dganic,
>  On Mon, Feb 06, 2012 at 09:17:33PM +0300, dganic@bmail.ru wrote:
> >Subject: drivers realtek rtl8191su [rtl8712 ]
> >
> >Good day, https://github.com/torvalds/linux/blob/master/drivers/staging/rtl8712/TODO,
> >there indicated that in a short time you make a "switch to use
> >MAC80211" and as what about "nl80211" I want to do from wi fi card,
> >access point, by means of hostapd, but in this implementation, the
> >driver who is at the core, this is impossible, in which release of
> >the kernel will be implemented this functionality the driver?
>  Yes, I was the one who had volunteered to try the implementation.
> But,
>  unfortunately, I can't work on this driver anymore; I stopped in
>  September. So, as far as I know, this is not going to happen anytime
>  soon.
>  regards,
>  ali
