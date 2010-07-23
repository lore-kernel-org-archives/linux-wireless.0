Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isilmar-3.linta.de ([188.40.101.200]:33258 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751733Ab0GWI1Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 04:27:25 -0400
Date: Fri, 23 Jul 2010 10:27:10 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
Subject: Re: 2.6.35-rc5+ WARNING at net/mac80211/scan.c:262
Message-ID: <20100723082710.GA20251@comet.dominikbrodowski.net>
References: <20100721184040.GA22968@comet.dominikbrodowski.net>
 <1279802055.12439.16.camel@jlt3.sipsolutions.net>
 <20100722134048.GA28231@isilmar-3.linta.de>
 <1279807678.12439.17.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1279807678.12439.17.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 22, 2010 at 04:07:58PM +0200, Johannes Berg wrote:
> On Thu, 2010-07-22 at 15:40 +0200, Dominik Brodowski wrote:
> 
> > > http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-mac80211-hw-scan-locking.patch
> > 
> > patching file drivers/net/wireless/iwlwifi/iwl-core.c
> > Hunk #1 succeeded at 2103 (offset 102 lines).
> > Hunk #2 FAILED at 2015.
> > Hunk #3 succeeded at 2120 (offset 97 lines).
> > 1 out of 3 hunks FAILED -- saving rejects to file
> > drivers/net/wireless/iwlwifi/iwl-core.c.rej
> 
> Oh, it's against wireless-testing, which apparently has some other mods
> there. I'll have to see if any other patch needs to go into .35 too.

That's fine, I'll just test wireless-testing plus your patch from now on ;)

Best,
	Dominik
