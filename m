Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:32812 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824AbYHFTrR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 15:47:17 -0400
From: Chr <chunkeey@web.de>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: kernel panic on p54pci insertion on mipsel
Date: Wed, 6 Aug 2008 21:50:01 +0200
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>
References: <4898B018.5050202@wpkg.org> <43e72e890808051619u4ed7c447wd80a866192220b84@mail.gmail.com> <4899F540.8050409@wpkg.org>
In-Reply-To: <4899F540.8050409@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808062150.01765.chunkeey@web.de> (sfid-20080806_214720_601401_0FD342F8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 06 August 2008 21:02:24 Tomasz Chmielewski wrote:
> Luis R. Rodriguez schrieb:
>
> (...)
>
> >> - doesn't work with prism54.ko module (similar messages to
> >> http://marc.info/?l=linux-wireless&m=120250829717134&w=2)
> >
> > We need more details, or do you get *exactly* the same error messages?
> >
> > "Out of memory, cannot handle oid" comes up after a failed kmalloc()
> > while trying to handle an interrupt and management frame (not 802.11
> > frame) from the firmware. From that archived mailing list though the
> > oid 0x080002ff is mentioned and... well prism54 doesn't know what that
> > is. I wonder if the firmware is triggering random interrupts with
> > bogus oids.
> >
> > If you can provide a complete log it can help. Also in your previous
> > posts I see you mentioned you were working with different firmwares.
> > 1.0.4.3.arm should *only* be used with prism54. You may also want to
> > try an older firmware version than 1.0.4.3.arm, this one came from
> > 3com cards.
>
> Is older firmware available anywhere online?
you can get lots of fullmac & softmac firmwares right here:
http://daemonizer.de/prism54/prism54-fw/

Regards,
	Chr
