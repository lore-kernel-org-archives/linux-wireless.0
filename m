Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53512 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750926AbdCQIGz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Mar 2017 04:06:55 -0400
Message-ID: <1489737957.2544.1.camel@sipsolutions.net> (sfid-20170317_090709_711736_6C6ABB14)
Subject: Re: pull-request: mac80211 2017-03-16
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Fri, 17 Mar 2017 09:05:57 +0100
In-Reply-To: <20170316.111819.199681647414354942.davem@davemloft.net>
References: <20170316095156.31253-1-johannes@sipsolutions.net>
         <20170316.111819.199681647414354942.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-03-16 at 11:18 -0700, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Thu, 16 Mar 2017 10:51:55 +0100
> 
> > Here's the pull request you were waiting for. I went through all my
> > pending patches but only this one is applicable for net.git at this
> > time, so it's just a single one.
> > 
> > Since I didn't have a current base, I forwarded to net.git first
> > and re-validated the patch there, but you might might have to be
> > careful if you merge to not fast-fwd on your side (though, even
> > if you do that, I don't think it matters much).
> > 
> > Please pull and let me know if there's any problem.
> 
> I was able to fast-forward pull this, so it should be fine.

Great, thanks. I somehow thought that you might _not_ want the fast
forward, to preserve where the patch came from, but personally I don't
care.

Thanks for merging it so quickly!

johannes
