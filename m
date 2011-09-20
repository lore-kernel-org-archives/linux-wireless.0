Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59138 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab1ITNic (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 09:38:32 -0400
Date: Tue, 20 Sep 2011 09:36:28 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg KH <greg@kroah.com>, Franky Lin <frankyl@broadcom.com>,
	gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/20] staging: brcm80211: 7th reaction for mainline
 patch #2
Message-ID: <20110920133628.GC7800@tuxdriver.com> (sfid-20110920_153835_828886_C295C6B0)
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
 <20110920130338.GA9885@kroah.com>
 <1316524874.3953.41.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1316524874.3953.41.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 20, 2011 at 03:21:14PM +0200, Johannes Berg wrote:

> Now, don't get me wrong -- I don't think the duplication is a good
> thing. A lot of the PHY code could be shared. However, I think it will
> probably not be possible for much longer to share the higher level MAC
> code that programs the SHM etc.

It would be nice to see some of this.  I don't think anything is
stopping either Broadcom _or_ the b43 team from posting such patches.

> So I don't claim to know what the solution is, but I think simply
> rejecting the Broadcom effort like most people seem to imply is a good
> solution at all. It will leave all of us in a bad spot by creating a
> driver that has to support too many different devices.

I'm inclined to agree.  Despite recent heroic efforts, b43 remains
behind in it's support for current features of Broadcom hardware.
As developers find other gainful interests, that gap is sure to widen
-- it certainly was quite wide just a few months ago.

As Johannes implies, it seems likely that newer Broadcom hardware will
need to be supported by a different/new driver anyway.  Is there
some reason why that new driver needs to have a b43 pedigree?
If we want/expect Broadcom to support that new driver, is it so
unreasonable to allow them to start from the codebase they prefer?
I don't think it is.

Broadcom has come a long way in the wireless arena.  I think we would
be better served by bringing them into the fold than by continuing
to demand what they don't feel able to provide.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
