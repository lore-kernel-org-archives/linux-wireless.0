Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.u.tv ([194.46.8.62]:1185 "EHLO
	ni-mail1.dna.utvinternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753583AbXIQKQo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2007 06:16:44 -0400
Date: Mon, 17 Sep 2007 11:05:15 +0100
From: Gavin McCullagh <gmccullagh@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Fwd: [AirForce One 54g] working]
Message-ID: <20070917100515.GD1455@gmail.com>
Reply-To: Gavin McCullagh <gmccullagh@gmail.com>
References: <46EDAEC3.6020201@lwfinger.net> <1190022872.3934.6.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1190022872.3934.6.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, 17 Sep 2007, Johannes Berg wrote:

> On So, 2007-09-16 at 17:31 -0500, Larry Finger wrote:
> 
> > 1. I've been getting tonnes of syslog errors like this:
> > 	Sep 16 21:46:59 tilly kernel: [ 5171.869169] CCMP: decrypt failed: STA=00:09:5b:d2:f0:2f
> > 	Sep 16 21:46:59 tilly kernel: [ 5171.872336] CCMP: decrypt failed: STA=00:18:84:11:78:d6
> > 	Sep 16 21:47:05 tilly kernel: [ 5174.178449] printk: 122 messages suppressed.
> >    which all seem to correspond to packets tranferred between my AP and
> >    a second netgear laptop with an atheros chipset.  So it's not a worry.
> >    ifconfig shows a collossal packet drop count, which seems to
> >    approximately equal the number of packets sent+rec'd  by the other
> >    laptop so I guess it's the same error as above.  Perhaps there's a good
> >    debug reason for these printk statements, but they have their cost on the
> >    machine.
> 
> Which of my patches do you have applied? I'll look into it at the end of
> the week.

I'll have to have a look when I get home, but I didn't apply any patches, I
simply downloaded the wireless-dev tree from git.kernel.org.  

I'm not very git-knowledgeable yet, so is there some command I can run to
give you the info you need?

Gavin

