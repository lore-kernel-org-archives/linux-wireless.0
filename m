Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isilmar-3.linta.de ([188.40.101.200]:54643 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757995Ab0GVNkv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 09:40:51 -0400
Date: Thu, 22 Jul 2010 15:40:48 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
Subject: Re: 2.6.35-rc5+ WARNING at net/mac80211/scan.c:262
Message-ID: <20100722134048.GA28231@isilmar-3.linta.de>
References: <20100721184040.GA22968@comet.dominikbrodowski.net> <1279802055.12439.16.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1279802055.12439.16.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> > [82970.511341] ------------[ cut here ]------------
> > [82970.511365] WARNING: at net/mac80211/scan.c:262 ieee80211_scan_completed+0x137/0x1d0()
> 
> You don't happen to have a way of reproducing this? I have been
> suspecting races in this area, and came up with this patch to fix them,

No, but as it happened again today, I would be willing to test it out.

> but haven't really validated it yet:
>
> http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-mac80211-hw-scan-locking.patch

patching file drivers/net/wireless/iwlwifi/iwl-core.c
Hunk #1 succeeded at 2103 (offset 102 lines).
Hunk #2 FAILED at 2015.
Hunk #3 succeeded at 2120 (offset 97 lines).
1 out of 3 hunks FAILED -- saving rejects to file
drivers/net/wireless/iwlwifi/iwl-core.c.rej

:(

Best,
	Dominik
