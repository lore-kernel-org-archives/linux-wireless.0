Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2302 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbZFTQOz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jun 2009 12:14:55 -0400
Date: Sat, 20 Jun 2009 12:12:17 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: Re: lockdep spew
Message-ID: <20090620161217.GA26000@hash.localnet>
References: <20090619113049.GB18956@hash.localnet> <1245412823.16399.18.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1245412823.16399.18.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 19, 2009 at 02:00:23PM +0200, Johannes Berg wrote:
> > [  966.937836] ======================================================
> > [  966.937855] [ INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected ]
> > [  966.937863] 2.6.30-wl #136
> > [  966.937869] ------------------------------------------------------
> 
> I think this will be fixed by the local_bh_disable patch I posted
> recently.

This one?

    commit 38d64294a1116bef7cde45eef3a4554d6d628123
    Author: Johannes Berg <johannes@sipsolutions.net>
    Date:   Thu Jun 18 17:25:11 2009 +0200

        mac80211: fix ieee80211_xmit call context

Hmm, I still have it with that.

-- 
Bob Copeland %% www.bobcopeland.com

