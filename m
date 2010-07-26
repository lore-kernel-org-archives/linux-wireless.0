Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isilmar-3.linta.de ([188.40.101.200]:45639 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753335Ab0GZIRY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 04:17:24 -0400
Date: Mon, 26 Jul 2010 10:17:13 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
Subject: Re: 2.6.35-rc5+ WARNING at net/mac80211/scan.c:262
Message-ID: <20100726081713.GA14192@comet.dominikbrodowski.net>
References: <20100721184040.GA22968@comet.dominikbrodowski.net>
 <1279802055.12439.16.camel@jlt3.sipsolutions.net>
 <20100722134048.GA28231@isilmar-3.linta.de>
 <1279807678.12439.17.camel@jlt3.sipsolutions.net>
 <20100723082710.GA20251@comet.dominikbrodowski.net>
 <1279873990.3745.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1279873990.3745.1.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey,

On Fri, Jul 23, 2010 at 10:33:10AM +0200, Johannes Berg wrote:
> > > Oh, it's against wireless-testing, which apparently has some other mods
> > > there. I'll have to see if any other patch needs to go into .35 too.
> > 
> > That's fine, I'll just test wireless-testing plus your patch from now on ;)
> 
> Hah, ok, I made a note to backport the patch for you, guess I'll delete
> it. Wouldn't have gotten around to it today anyway I think.

the problem didn't reappear when using wireless-testing plus your patch. As
I can't reproduce it -- it just happened every once in a while (maybe once a
day?) -- this doesn't necessarily mean the bug is fixed, but...

Best,
	Dominik
