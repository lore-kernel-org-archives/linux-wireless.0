Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35530 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbZFZGAv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2009 02:00:51 -0400
Date: Fri, 26 Jun 2009 07:46:43 +0200
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/3] wireless extensions improvements
Message-ID: <20090626054642.GA4911@tuxdriver.com>
References: <20090624113447.441667549@sipsolutions.net> <20090625.161817.112930127.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090625.161817.112930127.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 25, 2009 at 04:18:17PM -0700, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Wed, 24 Jun 2009 13:34:47 +0200
> 
> > This series contains three improvements to wireless
> > extensions:
> >  1) make them network namespace aware, as discussed
> >     previously
> >  2) optimise the event sending code and fix a small
> >     heap information leak
> >  3) do some generic work and make it possible to send
> >     compat netlink events, and make wext do this
> > 
> > Because the third patch depends on the first two (it
> > could be made not to, if you wish) but touches generic
> > networking stuff, I'd like to have all of these included
> > in net-next instead of John's wireless tree, all the
> > other wireless work can be done independently of these.
> 
> These changes look fine to me, so I'll likely put them into
> net-next-2.6 as soon as I open that up.

ACK

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
