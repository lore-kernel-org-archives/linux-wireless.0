Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39475 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbYKSCBL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2008 21:01:11 -0500
Date: Tue, 18 Nov 2008 20:54:54 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	sfr@canb.auug.org.au
Subject: Re: pull request: wireless-2.6 2008-11-18
Message-ID: <20081119015453.GA10311@tuxdriver.com> (sfid-20081119_030116_457966_5239D840)
References: <20081119000719.GA19756@tuxdriver.com> <1227058418.4014.99.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1227058418.4014.99.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 19, 2008 at 02:33:38AM +0100, Johannes Berg wrote:
> > and a final one fixes some mysterious DMA alignment problems
> > that have been plaguing iwlwifi for some time.
> 
> 
> > The following changes since commit 5f9021cfdc3524a4c5e3d7ae2d049eb7adcd6776:
> >   Johannes Berg (1):
> >         rtnetlink: propagate error from dev_change_flags in do_setlink()
> 
> heh.
> 
> >      iwlagn: fix RX skb alignment
> 
> So Luis pointed out a bug in that, it might be useful to squish in this
> patch: http://marc.info/?l=linux-wireless&m=122705425425763&w=2
> 
> (also below for reference)
> 
> But we can also just add it on top, whichever way you prefer.

I'll get it in the next run, soon.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
