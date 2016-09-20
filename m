Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:45194 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751443AbcITIoW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 04:44:22 -0400
Date: Tue, 20 Sep 2016 04:44:19 -0400 (EDT)
Message-Id: <20160920.044419.79616518616678600.davem@davemloft.net> (sfid-20160920_104431_407027_0720E502)
To: johannes@sipsolutions.net
Cc: herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, tgraf@suug.ch, tom@herbertland.com,
        greearb@candelatech.com
Subject: Re: [v3 PATCH 0/2] rhashtable: rhashtable with duplicate objects
From: David Miller <davem@davemloft.net>
In-Reply-To: <1474284732.6544.2.camel@sipsolutions.net>
References: <20160919105854.GA12892@gondor.apana.org.au>
        <1474283023.6544.0.camel@sipsolutions.net>
        <1474284732.6544.2.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 19 Sep 2016 13:32:12 +0200

> On Mon, 2016-09-19 at 13:03 +0200, Johannes Berg wrote:
>> On Mon, 2016-09-19 at 18:58 +0800, Herbert Xu wrote:
>> > 
>> > v3 fixes a bug in the remove path that causes the element count
>> > to decrease when it shouldn't, leading to a gigantic hash table
>> > when it underflows.
>> > 
>> Ok, with the BUG_ON() thrown in, this works in the test that was
>> failing before. I'll run the entire suite again over lunch.
>> 
> 
> Ok, the entire test suite passed (with the BUG_ON, but hey).
> 
> Dave, let me know what you want to do (or have done, as it may be).

I'll apply this directly to net-next and push it out after some
build testing.

Thanks guys.
