Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50411 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab2GMJdN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 05:33:13 -0400
Message-ID: <1342171989.4983.2.camel@jlt3.sipsolutions.net> (sfid-20120713_113316_695737_0C17754E)
Subject: Re: BCM4313 injection support
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: sheerapthinath <sheerapthinath@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 13 Jul 2012 11:33:09 +0200
In-Reply-To: <4FFFEAD3.6070203@broadcom.com>
References: <CAJuQfSjWuF=APbRTGbQoBi4fzusd_-CNfBrmS2WOoFWJd1A_hg@mail.gmail.com>
	 <4FFFEAD3.6070203@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-07-13 at 11:30 +0200, Arend van Spriel wrote:
> On 07/13/2012 09:37 AM, sheerapthinath wrote:
> > Hi linux wireless,
> > 
> > Is there hardware support for injection in BCM4313 wireless card(PCI
> > id:14e4:4727)?
> > I only that driver has partial support  without injection. I dunno if
> > there is hardware support.
> > Can you please let me know the details?
> 
> From the documentation in [1] I see that mac80211 can handle this on a
> monitor interface. brcmsmac does support monitoring, but I am not sure
> what functionality is needed in the brcmsmac driver for injection. Maybe
> Johannes can elaborate.

You just get a normal TX, but without a sta pointer.

johannes

