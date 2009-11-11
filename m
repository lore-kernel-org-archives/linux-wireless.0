Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49813 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbZKKAaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 19:30:15 -0500
Date: Tue, 10 Nov 2009 19:19:45 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Rui Paulo <rpaulo@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 11/20] mac80211: implement RANN processing and
	forwarding
Message-ID: <20091111001944.GA3087@tuxdriver.com>
References: <20091110134802.GA55552@asus-p5b.lan> <20091110214350.GF12682@tuxdriver.com> <1E46D638-5BD4-4B59-9800-9A70595720B9@gmail.com> <1257894879.7037.70.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1257894879.7037.70.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 11, 2009 at 12:14:39AM +0100, Johannes Berg wrote:
> On Tue, 2009-11-10 at 23:03 +0000, Rui Paulo wrote:
> > Hi John,
> > 
> > On 10 Nov 2009, at 21:43, John W. Linville wrote:
> > > In file included from net/wireless/lib80211.c:19:
> > > include/linux/ieee80211.h:566: error: ‘ETH_ALEN’ undeclared here (not in a function)
> > 
> > Hmm, I must've busted my testing procedure. I'm sorry.
> > 
> > Anyway, I noticed that nothing uses ETH_ALEN in ieee80211.h and there
> > are quite some places we could use it. Should we include if_ether.h in
> > ieee80211.h (probably too evil) or should I just keep using 6 instead
> > of ETH_ALEN ?
> 
> When John mentioned this I remembered falling into that trap before ..
> maybe better to just keep using 6, sorry!

I don't much care either way.  FWIW I would tend to prefer ETH_ALEN
over 6, so long as it doesn't break the build... :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
