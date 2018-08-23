Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:38132 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbeHWUKG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 16:10:06 -0400
Message-ID: <1535042363.9999.4.camel@sipsolutions.net> (sfid-20180823_183949_047066_916A1212)
Subject: Re: [PATCH] netlink: add nl_set_extack_cookie_u64()
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Thu, 23 Aug 2018 18:39:23 +0200
In-Reply-To: <20180823.084510.864066255490001088.davem@davemloft.net>
References: <20180823084813.5727-1-johannes@sipsolutions.net>
         <20180823.084510.864066255490001088.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-08-23 at 08:45 -0700, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Thu, 23 Aug 2018 10:48:13 +0200
> 
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Add a helper function nl_set_extack_cookie_u64() to use a u64 as
> > the netlink extended ACK cookie, to avoid having to open-code it
> > in any users of the cookie.
> > 
> > A u64 should be sufficient for most subsystems though we allow
> > for up to 20 bytes right now. This also matches the cookies in
> > nl80211 where I intend to use this.
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> Feel free to merge this in your wireless tree since the first
> user will be there.
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Will do, thanks.

johannes
