Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38996 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab0LOQpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 11:45:07 -0500
Date: Wed, 15 Dec 2010 11:37:30 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/22] rtl8192ce: Initial upload of driver
Message-ID: <20101215163730.GF2377@tuxdriver.com>
References: <4D08EA6D.6070106@lwfinger.net>
 <1292430400.3678.10.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1292430400.3678.10.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 15, 2010 at 05:26:40PM +0100, Johannes Berg wrote:

> > If you prefer that it go to staging first, I will send it to GregKH, but since
> > it uses mac80211, I think it is ready for wireless.
> 
> It looks pretty clean -- so personally, I don't think I'd mind it going
> in directly.
> 
> Are you or somebody else planning to make changes to it though? It looks
> like for example the config semaphore could easily be replaced by a
> mutex for better debug, for example. Potentially, rate control could be
> internalised with IEEE80211_HW_HAS_RATE_CONTROL as well, and some
> similar minor things.

Sorry for the delay, Larry!  I've been meaning to post a thorough
review, but...busy, busy...

Anyway, I think Johannes is right -- whatever issues remain, it
would be better to get it in place now than to leave it out or push
it to staging.

I intend to mash the series together into a single patch when I merge
it -- I hope you don't mind.

Thanks,

JOhn
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
