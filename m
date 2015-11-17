Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:58630 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbbKQW2g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2015 17:28:36 -0500
Date: Wed, 18 Nov 2015 09:28:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: linux-next inclusion request for mac80211
Message-ID: <20151118092834.7956b883@canb.auug.org.au> (sfid-20151117_232855_497297_DD48941A)
In-Reply-To: <1447773252.14408.9.camel@sipsolutions.net>
References: <1447773252.14408.9.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Tue, 17 Nov 2015 16:14:12 +0100 Johannes Berg <johannes@sipsolutions.net> wrote:
>
> Could you please add my mac80211 and mac80211-next trees, found at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
> git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
> 
> with their 'master' branches to linux-next?
> 
> These trees are feeding net and net-next respectively, but I don't
> always send them immediately and it'd be good to have early integration
> with other things happening elsewhere, in particular of course with the
> wifi drivers found in wireless-drivers{,-next}.

Added from today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window. 

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
        Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and 
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

-- 
Cheers,
Stephen Rothwell 
sfr@canb.auug.org.au
