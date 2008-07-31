Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227AbYGaUC7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 16:02:59 -0400
Subject: Re: Driver for the FullMAC card
From: Dan Williams <dcbw@redhat.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Dmitry <dbaryshkov@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1217517571.22143.17.camel@dv>
References: <g6qr98$q28$2@ger.gmane.org>
	 <1217512488.12016.8.camel@localhost.localdomain>
	 <bc64b4640807310715j41bb0029i5c8be73a311ed52@mail.gmail.com>
	 <1217514241.12016.13.camel@localhost.localdomain>
	 <1217517571.22143.17.camel@dv>
Content-Type: text/plain
Date: Thu, 31 Jul 2008 16:00:15 -0400
Message-Id: <1217534415.9377.12.camel@localhost.localdomain> (sfid-20080731_220315_566069_7A64ACD5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-07-31 at 11:19 -0400, Pavel Roskin wrote:
> On Thu, 2008-07-31 at 10:24 -0400, Dan Williams wrote:
> 
> > prism2_usb already uses p80211, which is a softmac stack.  So the cards
> > are already being driven in softmac mode.  You basically just have to
> > write a mac80211 driver for the hardware and ignore p80211 completely.
> 
> I don't think p80211 is a softmac stack.  It's just a thin layer for
> 802.11 packet manipulation.  There were some talks about splitting
> lib80211 from mac80211 so that FullMAC cards could make use of the
> existing code.  p80211 is something of that kind.
> 
> Prism USB is not much different from other Prism cards.  Sure, it needs
> packet interface for communicating to the device, but it associates on
> its own.
> 
> I asked Jouni if HostAP could be converted to SoftMAC, and his answer
> was that it may be a good AP but a poor station (sorry I cannot find it
> in the archives).  The same would apply to Prism USB.

Guess I misunderstood the scope of p80211 then.  So the prism2 usb stuff
really is fullmac then?  Or at least quasi-mac like the ipw2x00 cards?

Dan


