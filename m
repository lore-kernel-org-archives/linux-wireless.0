Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52901 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab0GWIeH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 04:34:07 -0400
Subject: Re: 2.6.35-rc5+ WARNING at net/mac80211/scan.c:262
From: Johannes Berg <johannes@sipsolutions.net>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <20100723082710.GA20251@comet.dominikbrodowski.net>
References: <20100721184040.GA22968@comet.dominikbrodowski.net>
	 <1279802055.12439.16.camel@jlt3.sipsolutions.net>
	 <20100722134048.GA28231@isilmar-3.linta.de>
	 <1279807678.12439.17.camel@jlt3.sipsolutions.net>
	 <20100723082710.GA20251@comet.dominikbrodowski.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Jul 2010 10:33:10 +0200
Message-ID: <1279873990.3745.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-07-23 at 10:27 +0200, Dominik Brodowski wrote:
> On Thu, Jul 22, 2010 at 04:07:58PM +0200, Johannes Berg wrote:
> > On Thu, 2010-07-22 at 15:40 +0200, Dominik Brodowski wrote:
> > 
> > > > http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-mac80211-hw-scan-locking.patch
> > > 
> > > patching file drivers/net/wireless/iwlwifi/iwl-core.c
> > > Hunk #1 succeeded at 2103 (offset 102 lines).
> > > Hunk #2 FAILED at 2015.
> > > Hunk #3 succeeded at 2120 (offset 97 lines).
> > > 1 out of 3 hunks FAILED -- saving rejects to file
> > > drivers/net/wireless/iwlwifi/iwl-core.c.rej
> > 
> > Oh, it's against wireless-testing, which apparently has some other mods
> > there. I'll have to see if any other patch needs to go into .35 too.
> 
> That's fine, I'll just test wireless-testing plus your patch from now on ;)

Hah, ok, I made a note to backport the patch for you, guess I'll delete
it. Wouldn't have gotten around to it today anyway I think.

johannes

