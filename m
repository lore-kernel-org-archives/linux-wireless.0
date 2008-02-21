Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2615 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761448AbYBUUDL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 15:03:11 -0500
Date: Thu, 21 Feb 2008 14:43:07 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: bruno randolf <br1@einfach.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: fix IBSS code
Message-ID: <20080221194307.GL3094@tuxdriver.com> (sfid-20080221_200319_883905_AB9C8EA6)
References: <1203588513.17534.138.camel@johannes.berg> <20080221170710.GG3094@tuxdriver.com> <1203621836.26341.4.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1203621836.26341.4.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 21, 2008 at 08:23:56PM +0100, Johannes Berg wrote:
> 
> On Thu, 2008-02-21 at 12:07 -0500, John W. Linville wrote:
> > On Thu, Feb 21, 2008 at 11:08:33AM +0100, Johannes Berg wrote:
> > > This patch fixes two errors introduced by
> > > 
> > >     commit 19d35612f3cd7f60dd9174c0100584e21f5a1025
> > >     Author: Bruno Randolf <bruno@thinktube.com>
> > >     Date:   Mon Feb 18 11:21:36 2008 +0900
> > > 
> > >         mac80211: enable IBSS merging
> > > 
> > > The first error is an endianness problem that sparse found and
> > > the second is a build failure when CONFIG_MAC80211_IBSS_DEBUG
> > > is not set.
> > 
> > I think I like Pavel's fix for the CONFIG_MAC80211_IBSS_DEBUG build
> > issue better.  Do you want to repsin the sparse warning bit?  If you
> > like, I can respin it for you -- just let me know.
> 
> Eh, where do we stand now? Bruno wanted the message to not be rate
> limited in the DEBUG case, and the endianness fix is definitely
> required.

I'll rebase your original patch on top of what is there now.  I.E. the
result will be as if I had only applied your patch.

John
-- 
John W. Linville
linville@tuxdriver.com
