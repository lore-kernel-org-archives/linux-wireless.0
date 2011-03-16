Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46438 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab1CPIro (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 04:47:44 -0400
Date: Wed, 16 Mar 2011 04:47:39 -0400
From: Thomas Graf <tgraf@infradead.org>
To: Jiri Pirko <jpirko@redhat.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, netfilter-devel@vger.kernel.org,
	eric.dumazet@gmail.com, linville@tuxdriver.com, kaber@trash.net
Subject: Re: net-next-2.6 status...
Message-ID: <20110316084739.GD26145@canuck.infradead.org>
References: <20110315.160124.104058374.davem@davemloft.net>
 <20110316065008.GA2780@psychotron.redhat.com>
 <20110316.000251.189704695.davem@davemloft.net>
 <20110316073803.GB2780@psychotron.redhat.com>
 <20110316084022.GA2845@psychotron.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110316084022.GA2845@psychotron.brq.redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 16, 2011 at 09:40:23AM +0100, Jiri Pirko wrote:
> >What do you suggest? To remove unused flags and leave gaps there or to
> >not to remove the flags at all?
> 
> Well, the following comment:
> <quote>
> /* Private (from user) interface flags (netdevice->priv_flags). */
> </quote>
> leads me to think that these flags should not be used by userspace.
> So maybe it may not be problem to change those values.

These flags should be moved to linux/netdevice.h
