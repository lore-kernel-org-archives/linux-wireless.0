Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:57992 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935299AbeFRUjO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 16:39:14 -0400
Message-ID: <1529354350.3092.34.camel@sipsolutions.net> (sfid-20180618_223955_770206_B7EEBF89)
Subject: Re: linux-next: Signed-off-by missing for commit in the
 mac80211-next tree
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Wireless <linux-wireless@vger.kernel.org>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 18 Jun 2018 22:39:10 +0200
In-Reply-To: <20180616223036.46abefcb@canb.auug.org.au>
References: <20180616223036.46abefcb@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2018-06-16 at 22:30 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Commit
> 
>   f9444b499f68 ("ieee80211: bump IEEE80211_MAX_AMPDU_BUF to support HE")
> 
> is missing a Signed-off-by from its author.

I messed up that commit, I'm really the author. Probably some git-am
left-over configuration. I guess I'll fix it.

Thanks for the heads-up!

johannes
