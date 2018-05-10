Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:37638 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752510AbeEJVfw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 17:35:52 -0400
Date: Thu, 10 May 2018 17:35:51 -0400 (EDT)
Message-Id: <20180510.173551.1677651998682798856.davem@davemloft.net> (sfid-20180510_233558_741451_C50BFD35)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2018-05-09
From: David Miller <davem@davemloft.net>
In-Reply-To: <1525901377.6910.29.camel@sipsolutions.net>
References: <20180509194034.11992-1-johannes@sipsolutions.net>
        <1525901377.6910.29.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 09 May 2018 23:29:37 +0200

> Hi,
> 
> Sorry, scratch that.
> 
> I forgot that this commit:
> 
>> Toke Høiland-Jørgensen (3):
> 
>>       cfg80211: Expose TXQ stats and parameters to userspace
> 
> caused a bunch of "too much stack" warnings - I should put in at least
> the non-driver fix for that first, and then coordinate with Kalle to
> send the driver fixes in too.

Ok, tossed.
