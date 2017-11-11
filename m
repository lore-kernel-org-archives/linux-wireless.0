Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:49110 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750752AbdKKNig (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 11 Nov 2017 08:38:36 -0500
Date: Sat, 11 Nov 2017 22:38:32 +0900 (KST)
Message-Id: <20171111.223832.2216321055833169803.davem@davemloft.net> (sfid-20171111_143853_112739_9C60DF97)
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2017-11-11
From: David Miller <davem@davemloft.net>
In-Reply-To: <87o9o9vugd.fsf@kamboji.qca.qualcomm.com>
References: <87o9o9vugd.fsf@kamboji.qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kvalo@codeaurora.org>
Date: Sat, 11 Nov 2017 15:03:14 +0200

> some more patches to net-next for v4.15. Even though I applied the last
> patch only on Saturday morning, all these have been tested by kbuild bot
> and most of them should also be in linux-next. Please let me know if
> there are any problems.

Pulled, but looking at your merge commit message:

> Major changes:
> 
> iwlwifi
> 
> * some new PCI IDs

I doubt this was the only major change in here :-)))
