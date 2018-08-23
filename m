Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:51070 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728082AbeHWTP2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 15:15:28 -0400
Date: Thu, 23 Aug 2018 08:45:10 -0700 (PDT)
Message-Id: <20180823.084510.864066255490001088.davem@davemloft.net> (sfid-20180823_174522_830539_A9754A23)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        johannes.berg@intel.com
Subject: Re: [PATCH] netlink: add nl_set_extack_cookie_u64()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20180823084813.5727-1-johannes@sipsolutions.net>
References: <20180823084813.5727-1-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 23 Aug 2018 10:48:13 +0200

> From: Johannes Berg <johannes.berg@intel.com>
> 
> Add a helper function nl_set_extack_cookie_u64() to use a u64 as
> the netlink extended ACK cookie, to avoid having to open-code it
> in any users of the cookie.
> 
> A u64 should be sufficient for most subsystems though we allow
> for up to 20 bytes right now. This also matches the cookies in
> nl80211 where I intend to use this.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Feel free to merge this in your wireless tree since the first
user will be there.

Acked-by: David S. Miller <davem@davemloft.net>
