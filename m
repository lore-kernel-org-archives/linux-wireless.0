Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0048.outbound.protection.outlook.com ([104.47.32.48]:34496
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751915AbdIUICA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2017 04:02:00 -0400
Date: Thu, 21 Sep 2017 11:01:48 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [v2,1/2] qtnfmac: lock access to h/w in tx path
Message-ID: <20170921080147.tvcztifyfwy2lp7g@bars> (sfid-20170921_100207_297460_0361B879)
References: <20170918122950.32612-2-sergey.matyukevich.os@quantenna.com>
 <20170920123553.7121D6070F@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170920123553.7121D6070F@smtp.codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello Kalle,

> > Fix tx path regression. Lock should be held when queuing packets
> > to h/w fifos in order to properly handle configurations with
> > multiple enabled interfaces.
> >
> > Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
> 
> 2 patches applied to wireless-drivers.git, thanks.
> 
> 20da2ec06bfa qtnfmac: lock access to h/w in tx path
> a715b3a0efe7 qtnfmac: cancel scans on wireless interface changes

Could you please clarify a couple of points regarding wireless-drivers-next
and wireless-drivers trees. I checked development process article at
wireless.wiki.kernel.org, but it looks a bit outdated. So am I correct
assuming the following:
- these two fixes were applied to wireless-drivers because I asked to
  to queue them to 4.14
- these two fixes will show up in wireless-drivers-next at some point
  in the future after you move wireless-drivers-next forward, rebasing
  it on top of one of the upcoming "-rc"

Regards,
Sergey
