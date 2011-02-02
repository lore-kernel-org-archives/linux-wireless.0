Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3500 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab1BBKxP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 05:53:15 -0500
Date: Wed, 2 Feb 2011 05:52:54 -0500
From: Bob Copeland <me@bobcopeland.com>
To: sedat.dilek@gmail.com
Cc: Bruno Randolf <br1@einfach.org>, linville@tuxdriver.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: Fix short and long retry configuration
Message-ID: <20110202105254.GA15843@hash.localnet>
References: <20110128075211.26919.39228.stgit@localhost6.localdomain6> <AANLkTim2MBSMSDxyokEWWDC=bwzMCO92qd4_i3Cm0h29@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTim2MBSMSDxyokEWWDC=bwzMCO92qd4_i3Cm0h29@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 02, 2011 at 09:06:40AM +0100, Sedat Dilek wrote:
> As I saw your patch in linux-next/wireless-next-2.6, I wanted to ask
> what's up with Bob's
> "mac80211-minstrel-honor-max-retry-counts-from-cfg80211.patch" (see
> [1])?

I sort of dropped the ball on it.  I guess I need to test it to
see if it actually works.  It may not properly handle reconfiguring
the limits, e.g.  Once I can boot a recent kernel (i915 issues) I'll
give it a spin and see. 

> Is this patch obsolete, now?

Ath5k now uses the same values that my patch would have used in
minstrel, so my patch wouldn't have any effect now, for ath5k.
There still might be other drivers that would benefit from having
the change in the rate controller.

-- 
Bob Copeland %% www.bobcopeland.com

