Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35838 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbZBZQP1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2009 11:15:27 -0500
Date: Thu, 26 Feb 2009 11:13:40 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2009-02-23
Message-ID: <20090226161340.GA4430@tuxdriver.com> (sfid-20090226_171531_503583_60685DD4)
References: <20090223192659.GB3553@tuxdriver.com> <1235457113.4455.89.camel@johannes.local> <20090224.235510.30497146.davem@davemloft.net> <1235637360.29050.16.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1235637360.29050.16.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 26, 2009 at 12:36:00AM -0800, Johannes Berg wrote:
> On Tue, 2009-02-24 at 23:55 -0800, David Miller wrote:
> > From: Johannes Berg <johannes@sipsolutions.net>
> > Date: Mon, 23 Feb 2009 22:31:53 -0800
> > 
> > > On Mon, 2009-02-23 at 14:26 -0500, John W. Linville wrote:
> > > 
> > > > Johannes Berg (10):
> > > >       mac80211: disallow moving netns
> > > >       mac80211: fix aggregation for hardware with ampdu queues
> > > >       mac80211: split IBSS/managed code
> > > >       genetlink: introduce pre/post methods
> > > 
> > > Hold off on this please, the genetlink patch here introduced a problem
> > > with locking and I'm going to rework/fix that.
> > 
> > Ok.
> > 
> > In fact it's better this way, since now John can send me the pull
> > request after the net-2.6 --> net-next-2.6 merge conflicts are
> > resolved.
> 
> Now I just have to get around to fixing it, it's proving to be harder
> than I thought, and I don't have much time right now.

I suppose I could just drop that one.  IIRC there was another patch
from you that depended upon that one as well?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
