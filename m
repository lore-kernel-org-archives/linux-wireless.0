Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37904 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab2EaJ6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 05:58:07 -0400
Received: by wgbdr13 with SMTP id dr13so723484wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 31 May 2012 02:58:05 -0700 (PDT)
From: Erwin Van de Velde <erwin.vandevelde@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Florian Fainelli <florian@openwrt.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: Master mode support in iwlagn?
Date: Thu, 31 May 2012 11:57:59 +0200
Message-ID: <5625918.SuzapvkoUg@sylvesterjr.cmi.ua.ac.be> (sfid-20120531_115812_044221_7D0C4C4B)
In-Reply-To: <4932187.SWLxM4x7cN@flexo>
References: <5252852.vpKViOerhF@sylvesterjr.cmi.ua.ac.be> <1338455399.7328.0.camel@jlt3.sipsolutions.net> <4932187.SWLxM4x7cN@flexo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 31 May 2012 11:20:49 Florian Fainelli wrote:
> Hi,
> 
> On Thursday 31 May 2012 11:09:59 Johannes Berg wrote:
> > Please don't top-post.
> > 
> > On Thu, 2012-05-31 at 11:03 +0200, Erwin Van de Velde wrote:
> > > What is the reasoning behind it? Why provide it for some wireless NICs
> > > and
> 
> not
> 
> > > for others? Seems quite odd for me and features like Internet sharing
> > > over
> > > wireless are not that exotic, are they?
> > 
> > This features requires extensive testing, space in the firmware that not
> > all devices have, integration, etc. It's not trivial to port to
> > different devices.
> 
> It certainly is not, but you can get some help from the software mac with
> that regard. Since your device is capable of beaconing for P2P and GO
> modes, Erwin's question is perfectly legitimate with respect to AP support.
> I suppose that you could get it working without too much firmware work.
> 
> At the same time, since Intel's iwlwifi series are targetted at the laptop
> market, and not AP/router solutions, it certainly was not in a roadmap to
> get AP mode supported. Apart from pleasing people, that won't make you sell
> more adapters.
> 

I am unable to give an opinion about the difficulty of this request, since I 
have never had a look at the code :-) However, theoretically I would expect 
that it is very similar to what is being done for other wireless drivers, but 
I can be wrong...

The interface may be targeted for the laptop market, but as I said, Internet 
sharing is quite handy sometimes and that is why I was looking for the AP 
mode.
I do not understand the last sentence... If you please customers, does that 
not lead to selling more of  your products? So, the question is: how many 
people would like to have this feature? And considering the availability of 
this option in other drivers, software like e.g. NetworkManager, other OSs 
like e.g. Max OSX, etc. I would like to argue that there is indeed a need for 
this feature in the market.

Best regards,
Erwin

