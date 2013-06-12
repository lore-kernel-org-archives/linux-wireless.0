Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47612 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab3FLTAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 15:00:13 -0400
Date: Wed, 12 Jun 2013 14:53:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Thomas =?iso-8859-1?Q?H=FChn?= <thomas@net.t-labs.tu-berlin.de>,
	linux-wireless@vger.kernel.org, nbd@nbd.name
Subject: Re: [PATCH] carl9170: make use of the new rate control API
Message-ID: <20130612185334.GH11589@tuxdriver.com> (sfid-20130612_210017_773056_89AA5276)
References: <1370966237-27716-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
 <1E3747D2-BD9C-4136-B17F-9227E24136D5@net.t-labs.tu-berlin.de>
 <1370978668.8356.67.camel@jlt4.sipsolutions.net>
 <201306112149.09768.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <201306112149.09768.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 11, 2013 at 09:49:09PM +0200, Christian Lamparter wrote:
> On Tuesday, June 11, 2013 09:24:28 PM Johannes Berg wrote:
> > On Tue, 2013-06-11 at 21:17 +0200, Thomas Hühn wrote:
> > > Hi Christian,
> > > 
> > > I have not seen that patch in wireless-next, that's why I overlooked it... sorry.
> You are right and it's not in wireless-testing.git either. That's a bit odd.
> 
> John,
> 
> was this patch overlooked/lost or was there a problem with it?
> (Or: can you please put it into wireless-next)

No idea, but I don't seem to have it.  Can you resend it?

> > > > carl9170 already supports the new rate control API (Patch from 2013-04-23).
> > > > <http://permalink.gmane.org/gmane.linux.kernel.wireless.general/107657>
> > > > 
> > > > Can you please tell me what you think is missing?
> > > > 
> > > 
> > > You patch looks good to me.
> > > As I just saw an ath9k patch for rcu protection when ieee80211_get_tx_rates() is called.
> > > Should this be done in carl9170 as well ?
> > 
> > I think that patch is wrong actually, probably should just do the rcu
> > protection inside the function. However the patch is completely wrong
> > anyway (C isn't python) so ...
> Uh, that's confusing. We are now talking about the patch from Thomas, right?
> If so: the previous "new rate control api" feature patch for carl9170 should
> be fine in this regard.
> 
> Regards,
> 	Chr
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
