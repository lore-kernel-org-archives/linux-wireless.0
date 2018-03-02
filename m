Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:46838 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1428753AbeCBOvb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 09:51:31 -0500
Date: Fri, 02 Mar 2018 09:51:30 -0500 (EST)
Message-Id: <20180302.095130.1497212812516999950.davem@davemloft.net> (sfid-20180302_155138_698288_45923BF6)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2018-03-02
From: David Miller <davem@davemloft.net>
In-Reply-To: <20180302090655.31669-1-johannes@sipsolutions.net>
References: <20180302090655.31669-1-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri,  2 Mar 2018 10:06:54 +0100

> Like before... Thanks for pulling net into net-next, the Add-BA patch
> below would otherwise not really be possible :-)

No problem.

> The only sort of interesting thing is the fast-RX improvements from
> Felix, they help on routers where these things (A-MSDU and 4-addr mode)
> are more important and where fast-RX really helps due to the reduced
> CPU load.
> 
> Please pull and let me know if there's any problem.

Ok, pulled, thanks Johannes.
