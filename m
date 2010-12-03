Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38069 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab0LCINi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 03:13:38 -0500
Subject: Re: [RFC 5/5 v2] cfg80211/mac80211: add mesh join/leave commands
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless@vger.kernel.org, Steve Derosier <steve@cozybit.com>,
	devel@lists.open80211s.org
In-Reply-To: <AANLkTi=o08ZBhF6KmYZ-jvAzM7WoMEZztNz+0Fc+WQQi@mail.gmail.com>
References: <20101201205939.009530439@sipsolutions.net>
	 <20101201210226.159495600@sipsolutions.net>
	 <1291279510.3481.17.camel@jlt3.sipsolutions.net>
	 <AANLkTik_C90v-313Pq_dPY7fE1OFG2X0uv8Ys+uGQFRt@mail.gmail.com>
	 <1291320849.3481.55.camel@jlt3.sipsolutions.net>
	 <AANLkTi=8yikvhvbUS86FZabM5qXbZ1LNHeT+2JQGU+QS@mail.gmail.com>
	 <1291325893.3481.56.camel@jlt3.sipsolutions.net>
	 <AANLkTi=o08ZBhF6KmYZ-jvAzM7WoMEZztNz+0Fc+WQQi@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Dec 2010 09:13:35 +0100
Message-ID: <1291364015.3499.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-02 at 15:08 -0800, Javier Cardona wrote:

> Not really.  Maybe this as PATCH 1/5 v3?

Sure, looks good.

> @@ -1585,6 +1588,7 @@ enum nl80211_meshconf_params {
>  	NL80211_MESHCONF_MAX_PEER_LINKS,
>  	NL80211_MESHCONF_MAX_RETRIES,
>  	NL80211_MESHCONF_TTL,
> +	NL80211_MESHCONF_ELEMENT_TTL,
>  	NL80211_MESHCONF_AUTO_OPEN_PLINKS,
>  	NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES,
>  	NL80211_MESHCONF_PATH_REFRESH_TIME,

except for this bit of course, it breaks ABI. I've fixed it up.

johannes

