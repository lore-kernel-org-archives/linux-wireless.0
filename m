Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58368 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693Ab0KQOOu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 09:14:50 -0500
Date: Wed, 17 Nov 2010 09:05:32 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: ext Arik Nemtsov <arik@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2 2/2] wl1271: add support for HW TX fragmentation
Message-ID: <20101117140531.GA2639@tuxdriver.com>
References: <1289209867-21422-1-git-send-email-arik@wizery.com>
 <1289209867-21422-3-git-send-email-arik@wizery.com>
 <1289472342.1606.25.camel@powerslave>
 <20101111163755.GC2559@tuxdriver.com>
 <1289982887.12140.2.camel@chilepepper>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1289982887.12140.2.camel@chilepepper>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 17, 2010 at 10:34:47AM +0200, Luciano Coelho wrote:
> Hi John,
> 
> On Thu, 2010-11-11 at 17:37 +0100, ext John W. Linville wrote:
> > On Thu, Nov 11, 2010 at 12:45:42PM +0200, Luciano Coelho wrote:
> > > On Mon, 2010-11-08 at 10:51 +0100, ext Arik Nemtsov wrote:
> > > > Indicate to mac80211 we support HW fragmentation.
> > > > Support updates of the fragmentation threshold via the
> > > > set_frag_threshold callback.
> > > > 
> > > > Signed-off-by: Arik Nemtsov <arik@wizery.com>
> > > > ---
> > > 
> > > Acked-by: Luciano Coelho <luciano.coelho@nokia.com>
> > > 
> > > John, can you apply this directly on your tree, due to the dependency on
> > > mac80211? There will be a merge conflict with my next pull-request, due
> > > to the driver renaming, but it should be very easily solvable.
> > > 
> > > The other option would be for me to wait until the mac80211 part is in
> > > wireless-next and only then I apply it to wl12xx.
> > > 
> > > Which one would you prefer?
> > 
> > I'll apply them, thanks.
> 
> I noticed that you applied the mac80211 patch but you didn't apply the
> wl12xx part.  So I have applied the latter myself now and will send it
> together with my next pull-request.
> 
> Please remove this patch from your "to-be-applied-inbox". ;)

Cool, thanks -- sorry for the confusion!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
