Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:54520 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751567AbdKULba (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 06:31:30 -0500
Date: Tue, 21 Nov 2017 20:31:27 +0900 (KST)
Message-Id: <20171121.203127.1032715998803915402.davem@davemloft.net> (sfid-20171121_123148_136294_88A7B547)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2017-11-20
From: David Miller <davem@davemloft.net>
In-Reply-To: <1511263472.2030.48.camel@sipsolutions.net>
References: <20171120160645.21074-1-johannes@sipsolutions.net>
        <20171121.201722.1123390949587944979.davem@davemloft.net>
        <1511263472.2030.48.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 21 Nov 2017 12:24:32 +0100

> On Tue, 2017-11-21 at 20:17 +0900, David Miller wrote:
>> From: Johannes Berg <johannes@sipsolutions.net>
>> Date: Mon, 20 Nov 2017 17:06:44 +0100
>> 
>> >   ssh://korg/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2017-11-20
>> 
>> That's an awesome URL, but I don't think I'll be able to pull
>> from it :-)
> 
> Huh. That's what I get for following Konstantin's advice to use
> insteadOf in git configuration ...
> 
> Should be
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2017-11-20
> 
> (or https if you prefer)

That works better, pulled, thanks!
