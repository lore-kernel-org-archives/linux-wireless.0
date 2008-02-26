Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46970 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbYBZBD1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 20:03:27 -0500
Subject: Re: [PATCH 00/13 v2] o11s: mesh interface support for mac80211
From: David Woodhouse <dwmw2@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <1203969040.13162.145.camel@johannes.berg>
References: <47be76f9.03b48c0a.025f.54f4@mx.google.com>
	 (sfid-20080222_071727_691746_9DC8AC76)  <1203693709.7082.35.camel@johannes.berg>
	 <1203968745.6929.30.camel@localhost>
	 (sfid-20080225_194425_609760_1B1ADCFD)  <1203969040.13162.145.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 20:03:20 -0500
Message-Id: <1203987800.2979.18.camel@shinybook.infradead.org> (sfid-20080226_010332_096674_2595B71E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2008-02-25 at 20:50 +0100, Johannes Berg wrote:
> > > >  - We no longer use directly rtnetlink for mesh peer link and mesh paths
> > > >    operation, and use nl80211 instead.
> > > 
> > > Nice too. What does libertas currently do btw?
> > > 
> > 
> > iwpriv...
> 
> eww, ok. Guess we can convert that, CC Dan & David.

Upstream libertas doesn't have the private ioctls. We have them as a
local hack in the OLPC tree only. I'll be happy to convert to a saner
generic API.

We also want some way to set the l2 ttl per-socket.

-- 
dwmw2

