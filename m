Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42490 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab1K2Npk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 08:45:40 -0500
Date: Tue, 29 Nov 2011 08:42:43 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: pull request: wireless-next 2011-11-28
Message-ID: <20111129134243.GB2705@tuxdriver.com> (sfid-20111129_144549_598798_5E78899C)
References: <20111128200221.GD2681@tuxdriver.com>
 <1322554972.4110.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1322554972.4110.0.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 29, 2011 at 09:22:52AM +0100, Johannes Berg wrote:
> On Mon, 2011-11-28 at 15:02 -0500, John W. Linville wrote:
> 
> > Johannes Berg (12):
> 
> >       mac80211: use skb list for fragments
> >       mac80211: move fragment flag adjustment
> >       mac80211: make TX LED handling independent of fragmentation
> >       mac80211: transmit fragment list to drivers
> 
> Since you included these patches, can you please pick up "mac80211: fix
> TX warning" relatively quickly? It fixes a harmless but possibly
> recurring WARN_ON in this code.

It's already in wireless-next. :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
