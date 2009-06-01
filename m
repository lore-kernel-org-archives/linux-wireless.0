Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60004 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754278AbZFANdw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 09:33:52 -0400
Date: Mon, 1 Jun 2009 10:33:51 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: create useful userspace interface
Message-ID: <20090601133351.GI11011@khazad-dum.debian.net>
References: <1243524688.10632.0.camel@johannes.local> <9b2b86520905310213n7be56260lc0c2cf3c109fe065@mail.gmail.com> <1243763887.19302.29.camel@johannes.local> <1243796509.6570.35.camel@localhost.localdomain> <1243841639.5299.8.camel@johannes.local> <4A238EA2.4040106@tuffmail.co.uk> <20090601122839.GB11011@khazad-dum.debian.net> <1243859931.5299.17.camel@johannes.local> <20090601124553.GE11011@khazad-dum.debian.net> <1243860606.5299.21.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1243860606.5299.21.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 01 Jun 2009, Johannes Berg wrote:
> > I mean platform devices which remember state.  Those will be turned on/off
> > by the platform firmware at boot and often at resume time, and overriding
> > them in rfkill (especially if it is done later, by a rfkilld) will cause
> > some flicker (on/off/on, off/on/off) in certain situations.  
> > 
> > This is a regression, because the current interface doesn't suffer this
> > limitation.
> 
> Right, but that was already covered by the discussion and patch I just
> sent, no need to complain, afaict? What's your gripe with the current
> add-on patch that I just sent out?

I don't know if I have any gripes with your latest patch ;)  Can't test it
right now.  I was reacting to the comments in the thread.

On a related note, Johannes, would you be opposed to exporting something I
could call from thinkpad-acpi to request a radio state change on a rfkill
struct?   This would allow me to remove some of the mess in thinkpad-acpi.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
