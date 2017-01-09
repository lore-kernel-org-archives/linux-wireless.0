Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39616 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965461AbdAILRs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 06:17:48 -0500
Message-ID: <1483960659.17582.29.camel@sipsolutions.net> (sfid-20170109_121853_708900_69D3CD2D)
Subject: Re: pull-request: mac80211 2017-01-06
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Mon, 09 Jan 2017 12:17:39 +0100
In-Reply-To: <20170106.162725.481874783893198568.davem@davemloft.net>
References: <20170106123721.10970-1-johannes@sipsolutions.net>
         <20170106.162725.481874783893198568.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-01-06 at 16:27 -0500, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Fri,  6 Jan 2017 13:37:20 +0100
> 
> > Here's another fix for something I noticed while reviewing the code
> in
> > a new suggested patch that added another netlink socket destroy
> path.
> > 
> > Since the new patch would otherwise cause conflicts, it might be
> good
> > to pull net or Linus's next RC containing it into net-next, if you
> can.
> > 
> > Please pull and let me know if there's any problem.
> 
> Pulled,

Thanks :)

> I'll try to get this moving into net-next over the weekend.

> Remind me about this early next week if that ends up slipping through
> the cracks.

Actually, I just got the new version of the other patch and it turns
out that it's not necessary since the context for that new bit is small
enough to not have included the difference - so since you haven't done
that yet, no need to bother, sorry I didn't realize that earlier.

johannes
