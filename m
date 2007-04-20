Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49547
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1767262AbXDTVQd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2007 17:16:33 -0400
Date: Fri, 20 Apr 2007 14:16:36 -0700 (PDT)
Message-Id: <20070420.141636.78160146.davem@davemloft.net>
To: johannes@sipsolutions.net
Cc: shemminger@linux-foundation.org, linville@tuxdriver.com,
	flamingice@sourmilk.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wext: allow wext users without rtnl
From: David Miller <davem@davemloft.net>
In-Reply-To: <1177102423.5902.38.camel@johannes.berg>
References: <1177098521.5902.20.camel@johannes.berg>
	<20070420.133257.32722308.davem@davemloft.net>
	<1177102423.5902.38.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 20 Apr 2007 22:53:42 +0200

> Since the discussion came up due to dropping the rtnl from wext I think
> that it may be beneficial if we added rtnl locking to cfg80211 now to
> simplify migration away from wext which holds rtnl and then revisit the
> locking when we can drop wext completely from the mac80211 code. That
> would allow us to revisit rtnl locking for wext when we have completely
> migrated to cfg80211 and wext is only handled through cfg80211.
> 
> Does that sound like an acceptable way forward?

Sure.
