Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49567 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab2HPTVA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2012 15:21:00 -0400
Message-ID: <1345144855.4665.3.camel@jlt3.sipsolutions.net> (sfid-20120816_212105_292009_C9A28992)
Subject: Re: carl9170: Unintentional transmission in monitor mode?
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Marco Fonseca <marco@tampabay.rr.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 16 Aug 2012 21:20:55 +0200
In-Reply-To: <201208092143.28506.chunkeey@googlemail.com> (sfid-20120809_214346_909325_DCA204F2)
References: <20120809165434.GA13409@192.168.1.10>
	 <201208092143.28506.chunkeey@googlemail.com>
	 (sfid-20120809_214346_909325_DCA204F2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-08-09 at 21:43 +0200, Christian Lamparter wrote:
> On Thursday, August 09, 2012 06:54:34 PM Marco Fonseca wrote:
> > Hello All,
> > 
> > I've noticed unexpected transmissions from the AR9170 while in monitor mode
> > and using tcpdump (and sometimes without tcpdump running).  These
> > transmissions degrade (pretty significantly) performance of other STA/AP on
> > the channel (as seen by iperf going from 60mbit/s to almost nill).  As best I
> > can tell these transmissions never coalesces into an actual frame in the air
> > (at least not one I'm able to pick up with a second different adapter in
> > monitor mode).
> > 
> > Are there any known reasons/bugs on this?  Is there anyway to completely
> > silence the transmitter of the AR9170 while still allowing reception?
> > 
> yes. <http://www.spinics.net/lists/linux-wireless/msg88896.html>
> 
> a solution is described in:
> <http://www.spinics.net/lists/linux-wireless/msg89279.html>
> 
> (iw dev wlanX set monitor none - if I'm not mistaken)

I've seen this before too -- what flag causes the issue, and why?

johannes

