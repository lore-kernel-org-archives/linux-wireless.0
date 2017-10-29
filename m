Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0043.outbound.protection.outlook.com ([104.47.37.43]:43328
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750959AbdJ2Pce (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 11:32:34 -0400
Date: Sun, 29 Oct 2017 18:32:12 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
Subject: Re: [1/5] qtnfmac: modify full Tx queue error reporting
Message-ID: <20171029153211.4ynfo6wrh7q76efd@bars> (sfid-20171029_163242_004086_E516BCFF)
References: <20171015205327.9966-2-sergey.matyukevich.os@quantenna.com>
 <20171027084814.B3FCB60314@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171027084814.B3FCB60314@smtp.codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle,

> Failed to apply:
> 
> fatal: sha1 information is lacking or useless (drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c).
> error: could not build fake ancestor
> Applying: qtnfmac: modify full Tx queue recovery
> Patch failed at 0001 qtnfmac: modify full Tx queue recovery
> The copy of the patch that failed is found in: .git/rebase-apply/patch
> 
> 5 patches set to Changes Requested.
> 
> 10007281 [1/5] qtnfmac: modify full Tx queue error reporting
> 10007279 [2/5] qtnfmac: enable registration of more mgmt frames
> 10007283 [3/5] qtnfmac: drop nonexistent function declaration
> 10007285 [4/5] qtnfmac: modify full Tx queue recovery
> 10007287 [5/5] qtnfmac: advertise support of inactivity timeout

My assumption is that by default all the patches should cleanly apply to wireless-drivers-next.
I could apply the patch in question to wireless-drivers-next without any issues.
Rebase of the whole series on top of wireless-drivers-next looks good as well.
I will resend rebased patches as v2. Meanwhile do you have any idea what could go wrong ?
The error message looks scary...

Regards,
Sergey
