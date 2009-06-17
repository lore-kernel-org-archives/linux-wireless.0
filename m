Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53000 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879AbZFQMab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 08:30:31 -0400
Date: Wed, 17 Jun 2009 08:26:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jiri Pirko <jpirko@redhat.com>, Netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	davem <davem@davemloft.net>
Subject: Re: [RFC] net: refactor multicast/unicast address list
Message-ID: <20090617122616.GB2791@tuxdriver.com>
References: <1244889678.13033.6.camel@johannes.local> <1244896094.13033.8.camel@johannes.local> <20090616111842.GG3521@psychotron.englab.brq.redhat.com> <1245151771.9256.3.camel@johannes.local> <20090616123808.GK3521@psychotron.englab.brq.redhat.com> <1245193788.21287.66.camel@johannes.local> <20090617072100.GA3492@psychotron.englab.brq.redhat.com> <1245231024.19769.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1245231024.19769.0.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 17, 2009 at 11:30:24AM +0200, Johannes Berg wrote:
> On Wed, 2009-06-17 at 09:21 +0200, Jiri Pirko wrote:
> 
> > >I guess we could stick this one into wireless-testing, and then take it
> > >out again once your patch hits the tree and offers me similar API for
> > >list_head based multicast lists?
> > 
> > Or wait, I hope the patch will be ready in week tops.
> 
> Yeah, that's fine, I'll ask people to throw in the simple export patch
> for testing. Thanks for considering! Please disregard my work on
> mac80211, I'll rebase over your work.

If you need Jiri's patch in wireless-testing I can make arrangements
to cherry-pick it.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
