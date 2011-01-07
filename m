Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.stuge.se ([213.88.146.6]:48258 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752392Ab1AGPgJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 10:36:09 -0500
Message-ID: <20110107153607.11061.qmail@stuge.se>
Date: Fri, 7 Jan 2011 16:36:07 +0100
From: Peter Stuge <peter@stuge.se>
To: Ben Greear <greearb@candelatech.com>
Cc: "Luis R. Rodriguez" <lrodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [ath9k-devel] [PATCH 3/3] ath9k: Keep track of stations for
	debugfs.
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com> <1294361165-15308-3-git-send-email-greearb@candelatech.com> <AANLkTikjjKe96Ok09Yz1R_nqsoO+n-9X-abeF8VUoOwQ@mail.gmail.com> <4D267E4D.7000608@candelatech.com> <20110107024909.GD20431@tux> <4D2685CC.7020502@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D2685CC.7020502@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> > but at least other clueless users would not go over stable limit
> > you have found.
> 
> I think it's very likely that the problems I find are general
> issues that are just much easier to hit with lots of stations.

I strongly support this. I recognize several of your problems from my
attempts at using ath9k with only a single STA which was all but stable.


> There is probably no 'safe' number of stations...just takes longer
> to see bugs with fewer stations.
> 
> For instance, you still see the failure-to-stop-DMA errors with a
> single station, right? And the tx locking stuff was just easier to
> exercise with lots of stations, but it would have been possible to
> hit it with 2 stations.
> 
> The current tx-hang stuff I'm chasing seems like logic bugs in the
> queueing, probably nothing in particular about the chipset.

This is also my impression. Since it is important for Atheros to have
bugzilla reports rather than discussion on list I will try to find
time for creating more and/or new bug reports about my problems.

(But the ones I have created so far did not really receive very good
response.)

Note that my AR9280 is not even detected correctly on PCI now so I
may switch back to AR5008 for that.

I really should try out FreeBSD too.


//Peter
