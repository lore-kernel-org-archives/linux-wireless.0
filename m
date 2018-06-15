Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0064.outbound.protection.outlook.com ([104.47.40.64]:55598
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934900AbeFOKDf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Jun 2018 06:03:35 -0400
Date: Fri, 15 Jun 2018 13:03:22 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Kalle Valo <kvalo@codeaurora.org>, kbuild-all@01.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [wireless-drivers-next:master 54/55]
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c:679:10-19: ERROR: vif is
 NULL but dereferenced. (fwd)
Message-ID: <20180615100321.5qivnu7ksfklazhs@bars> (sfid-20180615_120340_039158_6E9F09EE)
References: <alpine.DEB.2.20.1806151005520.3279@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.DEB.2.20.1806151005520.3279@hadrien>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello Julia,

> This report is a bit old, so perahsp the problem is already addressed.  In
> any case, the goto out on line 658 will lead to a null pointer
> dereference.
> 
> julia

Thanks for the issue report !

We have already received similar issue report together with the fix for it.
Fix has not yet been applied to wireless-drivers-next/master.
But, according to Kalle, it will be queued for 4.18.

By the way, the previous issue report was based on Coverity analysis.
Could you please clarify what kind of tool was used by kbuild robot
for analysis ? I couldn't figure this out from your logs.

Regards,
Sergey
