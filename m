Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0040.outbound.protection.outlook.com ([104.47.32.40]:42986
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751661AbdIUL4e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2017 07:56:34 -0400
Date: Thu, 21 Sep 2017 14:56:19 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [v2,1/2] qtnfmac: lock access to h/w in tx path
Message-ID: <20170921115618.xmrdwhylrp3ljmds@bars> (sfid-20170921_135639_854517_9B8E65D0)
References: <20170918122950.32612-2-sergey.matyukevich.os@quantenna.com>
 <20170920123553.7121D6070F@smtp.codeaurora.org>
 <20170921080147.tvcztifyfwy2lp7g@bars>
 <878th870u7.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <878th870u7.fsf@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > - these two fixes will show up in wireless-drivers-next at some point
> > in the future after you move wireless-drivers-next forward, rebasing
> > it on top of one of the upcoming "-rc"
> 
> I would not use the term "rebase" here, as that means rewriting the
> history which should be avoided on public trees. What I usually do is to
> "merge" (git pull) or "fast forward" (git pull --ff-only).
> 
> You are correct that eventually commits from wireless-drivers trickle
> down to wireless-drivers-next, I guess usually it takes something like
> 2-4 weeks. Most of them time they trickle down when Dave merges net to
> net-next and I fast forward wireless-drivers-next to latest net-next
> (after Dave has pulled from me). But occasionally I also merge
> wireless-drivers to wireless-drivers-next myself, for example I did that
> last cycle as there were major conflicts on iwlwifi and we wanted to fix
> those early on. The earlier the conflicts are resolved the smoother it
> is for everyone.

Understood.

> So if you have needs for getting the commits from wireless-drivers to
> wireless-drivers-next please let me know and let's see what's the best
> way forward.

Ok, good to know. But not this time, of course. We are keeping a bunch
of upcoming features and fixes in our internal tree on top of
wireless-drivers-next. So two more small patches for two more weeks
don't make any difference.

> Did this help?

Sure, thanks a lot for explanation!

Regards,
Sergey
