Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0061.outbound.protection.outlook.com ([104.47.37.61]:26304
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752487AbdJ3JpM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 05:45:12 -0400
Date: Mon, 30 Oct 2017 12:45:00 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
Subject: Re: [1/5] qtnfmac: modify full Tx queue error reporting
Message-ID: <20171030094459.kj6nnrrc52wj2bsp@bars> (sfid-20171030_104516_824844_0EADA82A)
References: <20171015205327.9966-2-sergey.matyukevich.os@quantenna.com>
 <20171027084814.B3FCB60314@smtp.codeaurora.org>
 <20171029153211.4ynfo6wrh7q76efd@bars>
 <87a8093vy7.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87a8093vy7.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > My assumption is that by default all the patches should cleanly apply
> > to wireless-drivers-next. I could apply the patch in question to
> > wireless-drivers-next without any issues.
> 
> Odd. How did you apply it? My script uses 'git am -s -3' individually
> for each patch in the series, but to my knowledge that shouldn't cause
> any problems.

It turns out I mechanically rebased my branch on top of w-d-n before writing
the previous email. Now I could reproduce the same failure when using this
command for the original patches downloaded from patchwork. The problem
was in conflict with qtnfmac fixes pulled to w-d-n from w-d.

Regards,
Sergey
