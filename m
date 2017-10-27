Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42044 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751176AbdJ0IsP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 04:48:15 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/5] qtnfmac: modify full Tx queue error reporting
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171015205327.9966-2-sergey.matyukevich.os@quantenna.com>
References: <20171015205327.9966-2-sergey.matyukevich.os@quantenna.com>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Message-Id: <20171027084814.B3FCB60314@smtp.codeaurora.org> (sfid-20171027_104820_898255_8E99278F)
Date: Fri, 27 Oct 2017 08:48:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> wrote:

> Under heavy load it is normal that h/w Tx queue is almost full all the time
> and reclaim should be done before transmitting next packet. Warning still
> should be reported as well as s/w Tx queues should be stopped in the
> case when reclaim failed.
> 
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Failed to apply:

fatal: sha1 information is lacking or useless (drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c).
error: could not build fake ancestor
Applying: qtnfmac: modify full Tx queue recovery
Patch failed at 0001 qtnfmac: modify full Tx queue recovery
The copy of the patch that failed is found in: .git/rebase-apply/patch

5 patches set to Changes Requested.

10007281 [1/5] qtnfmac: modify full Tx queue error reporting
10007279 [2/5] qtnfmac: enable registration of more mgmt frames
10007283 [3/5] qtnfmac: drop nonexistent function declaration
10007285 [4/5] qtnfmac: modify full Tx queue recovery
10007287 [5/5] qtnfmac: advertise support of inactivity timeout

-- 
https://patchwork.kernel.org/patch/10007281/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
