Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:35114 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751676AbYG2PUK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 11:20:10 -0400
Date: Tue, 29 Jul 2008 11:18:30 -0400
From: Theodore Tso <tytso@MIT.EDU>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alistair John Strachan <alistair@devzero.co.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dsd@gentoo.org, kune@deine-taler.de, linux-wireless@vger.kernel.org
Subject: Re: 2.6.27-rc1: zd1211rw association fails
Message-ID: <20080729151830.GA5126@mit.edu> (sfid-20080729_172016_962610_5B4C0740)
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org> <200807291049.47342.alistair@devzero.co.uk> <1217326195.10489.10.camel@johannes.berg> <20080729120442.GE9378@mit.edu> <1217333359.10489.38.camel@johannes.berg> <1217333706.10489.40.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1217333706.10489.40.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 29, 2008 at 02:15:06PM +0200, Johannes Berg wrote:
> > If everybody's going to decide now to hit on _me_, I'll point out that
> > davem's MQ TX changes broke it
> 
> Of course that's not strictly true, it had been broken forever, it just
> happened to never show up before. And I mean forever, the original
> devicescape code that got in was already broken.

Sorry, no, I wasn't trying to blame you.  I understand that this was a
hard problem to fix, and it wasn't at all obvious that changes in one
part of the networking stack would break wireless stack due to bad
assumptions it had made, that had been hiding for quite some time.

The timing is just very unfortunate, since if -rc1 had been delayed by
just one more day so it could have incorporated it we would probably
reduce the large number of regression reports; a lot of people who
test -rc1 don't necessarily follow netdev or linux-wireless.

I'm of course also nervously building -rc1 and about to test it, since
I haven't had a chance to test anything since -git6, and I'm wondering
if some other regression may have been introduced since then.

Since it probably doesn't get said enough to everyone who works of
fixing bugs/regressions, thanks very much for your efforts; I (and
many other people) very much appreciate it!!

						- Ted
