Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36074 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab1FTTbb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 15:31:31 -0400
Date: Mon, 20 Jun 2011 15:24:18 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 00/27] mac80211: create mac80211_ prefix
Message-ID: <20110620192418.GB2251@tuxdriver.com> (sfid-20110620_213135_490116_4E855EA3)
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
 <1f42877e8c429b956640a6e9d97127fc@secure.sipsolutions.net>
 <87mxhg1zmb.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87mxhg1zmb.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 17, 2011 at 02:11:40PM +0300, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > On Tue, 14 Jun 2011 01:34:28 +0300, Kalle Valo wrote:
> >
> >> In this patchset I first fix some issues I found from the drivers,
> >> then create mac80211-compat.h to make the transition as smooth as
> >> possible and then start changing mac80211 itself.
> >
> > FWIW, I don't mind the rename, but I don't like the compat.h thing.
> > The transition won't be smoothed by this, it just means the transition
> > will drag out as things conflict etc.
> 
> My plan was that I will finish the transition and remove
> mac80211-compat.h before the next merge window. That way the file
> would not be in any of the official releases.
> 
> > If we want to rename, we'll need to bite the bullet eventually
> > anyway.
> 
> What do you suggest here? So that we should rename everything (both
> mac80211 and 19 drivers) in one go? If we do that, we would have to do
> everything in one patch to not break bisect, and it would be huge.
> 
> With mac80211-compat.h it's possible to break down the patches into
> small pieces. This makes it easier to create the patches and, most
> importantly, review them.
> 
> I'm willing to work on that huge patch if we so decide, but I'm not
> sure if that's the correct way.
> 
> Ah, while writing this I realised that I could instead rename symbols
> in mac80211.h one at a time and that way the patches would be smaller.
> Did you mean that?

Is there going to be another spin of this?

I had trouble applying patch 5 -- maybe this is something that is
best handled with a pull request?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
