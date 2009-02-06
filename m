Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:1998 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbZBFDvA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 22:51:00 -0500
Date: Thu, 5 Feb 2009 22:50:36 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	nbd@openwrt.org
Subject: Re: [PATCH 5/5] ath5k: Update reset code
Message-ID: <20090206035036.GA10581@hash.localnet> (sfid-20090206_045111_850584_B91C3C75)
References: <20090131023147.GE3342@makis> <20090204215706.GA5651@makis> <20090205154532.M30551@bobcopeland.com> <40f31dec0902051528q3c9f82c2v69c4689ed3b1592f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0902051528q3c9f82c2v69c4689ed3b1592f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 06, 2009 at 01:28:07AM +0200, Nick Kossifidis wrote:
> > This works much better, except I still get some hard hangs
> > occasionally.  Doesn't appear to be bmiss storm this time.  I did it
> > with a VT up and didn't get an oops; I guess I'll try a serial console
> > or some printks.
> 
> Did you disable BMISS interrupts on base.c ?

Nope this is just vanilla wireless testing + your patchset.

-- 
Bob Copeland %% www.bobcopeland.com

