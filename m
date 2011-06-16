Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:48972 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377Ab1FPMuK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2011 08:50:10 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1QXC1P-00026B-33
	for linux-wireless@vger.kernel.org; Thu, 16 Jun 2011 14:50:07 +0200
Received: from 190-21-174-37.baf.movistar.cl ([190-21-174-37.baf.movistar.cl])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jun 2011 14:50:07 +0200
Received: from andrew by 190-21-174-37.baf.movistar.cl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jun 2011 14:50:07 +0200
To: linux-wireless@vger.kernel.org
From: andrew cooke <andrew@acooke.org>
Subject: Could Aircrack Patches be Applied Upstream?
Date: Thu, 16 Jun 2011 12:44:00 +0000 (UTC)
Message-ID: <loom.20110616T143337-880@post.gmane.org> (sfid-20110616_145015_474965_342746DE)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

I understand that this is probably a known issue, and may be in hand, or have 
related politics, but if no-one ever asks then perhaps something is 
overlooked...

There is a patch available from aicrack (I'll add links below) that fixes an 
issue with "channel -1" when using (at least, from my experience) ath9k.  From 
the bug report thread, the patch seems to have been available for 9 months yet 
it appears to be missing from the kernel (more exactly, it's missing from 
opensuse 11.4, kernel 2.6.37 and I had to apply it to the latest compat-wireless 
2011-06-15).

There's also another patch mentioned in the aircrack docs.  I don't know what 
that one does, but it seems worth mentioning too.

So, please could these patches be included in the standard source?  At least the 
first is needed for aircrack to work correctly.

Thanks, and apologies if this has been discussed many times before (I did a 
quick search back - found lots of hits for aircrack, but not anything obviously 
addressing this).

Andrew

Instructions on applying patches with locations:
http://www.aircrack-ng.org/doku.php?id=compat-wireless

Patches:
http://patches.aircrack-ng.org/mac80211.compat08082009.wl_frag+ack_v1.patch
http://patches.aircrack-ng.org/channel-negative-one-maxim.patch

Related bug report:
http://trac.aircrack-ng.org/ticket/742


