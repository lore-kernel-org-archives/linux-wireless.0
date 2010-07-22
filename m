Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41719 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759501Ab0GVOIb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 10:08:31 -0400
Subject: Re: 2.6.35-rc5+ WARNING at net/mac80211/scan.c:262
From: Johannes Berg <johannes@sipsolutions.net>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <20100722134048.GA28231@isilmar-3.linta.de>
References: <20100721184040.GA22968@comet.dominikbrodowski.net>
	 <1279802055.12439.16.camel@jlt3.sipsolutions.net>
	 <20100722134048.GA28231@isilmar-3.linta.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 16:07:58 +0200
Message-ID: <1279807678.12439.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-07-22 at 15:40 +0200, Dominik Brodowski wrote:

> > http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-mac80211-hw-scan-locking.patch
> 
> patching file drivers/net/wireless/iwlwifi/iwl-core.c
> Hunk #1 succeeded at 2103 (offset 102 lines).
> Hunk #2 FAILED at 2015.
> Hunk #3 succeeded at 2120 (offset 97 lines).
> 1 out of 3 hunks FAILED -- saving rejects to file
> drivers/net/wireless/iwlwifi/iwl-core.c.rej

Oh, it's against wireless-testing, which apparently has some other mods
there. I'll have to see if any other patch needs to go into .35 too.

johannes

