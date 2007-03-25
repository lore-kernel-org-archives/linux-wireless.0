Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:48960 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751872AbXCYQU0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Mar 2007 12:20:26 -0400
Message-ID: <4606A143.60105@lwfinger.net>
Date: Sun, 25 Mar 2007 11:20:19 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	Bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] bcm43xx: Fix machine check on PPC for version 1 PHY
References: <46067d12.1uF8l72xIYAG6Vyb%Larry.Finger@lwfinger.net> <20070325112235.tjuz5c04kcs4044g@webmail.spamcop.net>
In-Reply-To: <20070325112235.tjuz5c04kcs4044g@webmail.spamcop.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> Hi, Larry!
> 
> That was quick!  I confirm that the patch fixes the machine check for me.  The
> driver is working, even with WEP.  To prove my point, I'll send this message
> over the fixed driver, so if you can read it, you have made an excellent job :)

Thanks, but David Woodhouse deserves the credit.

In future cases, I'll send any changes that modify phy->rev == 1 behavior past you and David before
submitting. Too bad that one doesn't get the machine check on x86 architectures as I also have a rev
1 cards.

Larry

