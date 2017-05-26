Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:41104 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761186AbdEZO6F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 May 2017 10:58:05 -0400
Date: Fri, 26 May 2017 10:58:03 -0400 (EDT)
Message-Id: <20170526.105803.2151646617349245343.davem@davemloft.net> (sfid-20170526_165831_972642_E1A5138A)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC] skbuff: introduce skb_put_zero()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1495781929.2572.0.camel@sipsolutions.net>
References: <20170524070747.18573-1-johannes@sipsolutions.net>
        <20170525.130117.551364108206528221.davem@davemloft.net>
        <1495781929.2572.0.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 26 May 2017 08:58:49 +0200

> On Thu, 2017-05-25 at 13:01 -0400, David Miller wrote:
>> From: Johannes Berg <johannes@sipsolutions.net>
>> Date: Wed, 24 May 2017 09:07:47 +0200
>> 
>> > From: Johannes Berg <johannes.berg@intel.com>
>> > 
>> > This pattern was introduced a number of times in mac80211 just now,
>> > and since it's present in a number of other places it makes sense
>> > to add a little helper for it.
>> > 
>> > The transformations of all code were done with the following
>> spatch:
> [...]
>> > NB: the patch won't apply to net-next because a few of the mac80211
>> >     users don't exist there yet
>> 
>> Acked-by: David S. Miller <davem@davemloft.net>
>> 
>> No objections, feel free to push this in via your mac80211 tree.
> 
> Do you think I should include the conversions in other drivers, or
> would you prefer to get those as a separate patch later?

Probably better to keep that as a separate patch.
