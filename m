Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:38140 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936875AbeF3MRb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Jun 2018 08:17:31 -0400
Date: Sat, 30 Jun 2018 21:17:28 +0900 (KST)
Message-Id: <20180630.211728.888180353537471428.davem@davemloft.net> (sfid-20180630_141735_935713_64DD25D6)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2018-06-29
From: David Miller <davem@davemloft.net>
In-Reply-To: <20180629115906.2045-1-johannes@sipsolutions.net>
References: <20180629115906.2045-1-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 29 Jun 2018 13:59:05 +0200

> Here's the next round of -next updates. This includes the promised
> HE stuff but it's not all that big in the end, most of it is just
> additions to the protocol header file :-)

:-)

> Please pull and let me know if there's any problem.

There was a small merge conflict in net/mac80211/scan.c, I arranged
it such that the kcalloc() conversion was preserved.

Please send me any necessary fixups if I didn't do it properly.

Thanks.
