Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:33618 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751455AbeBWP26 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Feb 2018 10:28:58 -0500
Date: Fri, 23 Feb 2018 10:28:55 -0500 (EST)
Message-Id: <20180223.102855.480775675752406143.davem@davemloft.net> (sfid-20180223_162905_579672_152CFA8A)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2018-02-22
From: David Miller <davem@davemloft.net>
In-Reply-To: <1519385379.2231.10.camel@sipsolutions.net>
References: <20180222201619.30037-1-johannes@sipsolutions.net>
        <20180222.151902.347947675667607885.davem@davemloft.net>
        <1519385379.2231.10.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 23 Feb 2018 12:29:39 +0100

> On Thu, 2018-02-22 at 15:19 -0500, David Miller wrote:
>> 
>> Pulled, thank you!
> 
> Thanks. I just realized that I have a patch pending for -next that
> depends another commit in net/mac80211 (or would otherwise conflict
> badly while applying, and again while merging later), could I ask you
> to pull net into net-next at some point now?

I'll get that to happen in the next day or two.  Pablo asked for this
as well.
