Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40438 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab0GZIVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 04:21:43 -0400
Subject: Re: 2.6.35-rc5+ WARNING at net/mac80211/scan.c:262
From: Johannes Berg <johannes@sipsolutions.net>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <20100726081713.GA14192@comet.dominikbrodowski.net>
References: <20100721184040.GA22968@comet.dominikbrodowski.net>
	 <1279802055.12439.16.camel@jlt3.sipsolutions.net>
	 <20100722134048.GA28231@isilmar-3.linta.de>
	 <1279807678.12439.17.camel@jlt3.sipsolutions.net>
	 <20100723082710.GA20251@comet.dominikbrodowski.net>
	 <1279873990.3745.1.camel@jlt3.sipsolutions.net>
	 <20100726081713.GA14192@comet.dominikbrodowski.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Jul 2010 10:21:38 +0200
Message-ID: <1280132498.3693.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-07-26 at 10:17 +0200, Dominik Brodowski wrote:
> Hey,
> 
> On Fri, Jul 23, 2010 at 10:33:10AM +0200, Johannes Berg wrote:
> > > > Oh, it's against wireless-testing, which apparently has some other mods
> > > > there. I'll have to see if any other patch needs to go into .35 too.
> > > 
> > > That's fine, I'll just test wireless-testing plus your patch from now on ;)
> > 
> > Hah, ok, I made a note to backport the patch for you, guess I'll delete
> > it. Wouldn't have gotten around to it today anyway I think.
> 
> the problem didn't reappear when using wireless-testing plus your patch. As
> I can't reproduce it -- it just happened every once in a while (maybe once a
> day?) -- this doesn't necessarily mean the bug is fixed, but...

Alright, thanks. I don't suppose you tried wireless-testing w/o the
patch?

johannes

