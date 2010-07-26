Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55915 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab0GZIcu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 04:32:50 -0400
Subject: Re: 2.6.35-rc5+ WARNING at net/mac80211/scan.c:262
From: Johannes Berg <johannes@sipsolutions.net>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <20100726082754.GA14881@comet.dominikbrodowski.net>
References: <20100721184040.GA22968@comet.dominikbrodowski.net>
	 <1279802055.12439.16.camel@jlt3.sipsolutions.net>
	 <20100722134048.GA28231@isilmar-3.linta.de>
	 <1279807678.12439.17.camel@jlt3.sipsolutions.net>
	 <20100723082710.GA20251@comet.dominikbrodowski.net>
	 <1279873990.3745.1.camel@jlt3.sipsolutions.net>
	 <20100726081713.GA14192@comet.dominikbrodowski.net>
	 <1280132498.3693.2.camel@jlt3.sipsolutions.net>
	 <20100726082754.GA14881@comet.dominikbrodowski.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Jul 2010 10:32:46 +0200
Message-ID: <1280133166.3693.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-07-26 at 10:27 +0200, Dominik Brodowski wrote:

> > > the problem didn't reappear when using wireless-testing plus your patch. As
> > > I can't reproduce it -- it just happened every once in a while (maybe once a
> > > day?) -- this doesn't necessarily mean the bug is fixed, but...
> > 
> > Alright, thanks. I don't suppose you tried wireless-testing w/o the
> > patch?
> 
> No. Shall I?

Well, I'd be interested in whether or not my patch fixed it, but I think
I'll push it upstream anyway.

johannes

