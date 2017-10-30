Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59500 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752062AbdJ3Kze (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 06:55:34 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/5] qtnfmac: modify full Tx queue error reporting
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171030101350.21251-2-sergey.matyukevich.os@quantenna.com>
References: <20171030101350.21251-2-sergey.matyukevich.os@quantenna.com>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Message-Id: <20171030105533.A311860600@smtp.codeaurora.org> (sfid-20171030_115537_762043_253520FB)
Date: Mon, 30 Oct 2017 10:55:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> wrote:

> Under heavy load it is normal that h/w Tx queue is almost full all the time
> and reclaim should be done before transmitting next packet. Warning still
> should be reported as well as s/w Tx queues should be stopped in the
> case when reclaim failed.
> 
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

5 patches applied to wireless-drivers-next.git, thanks.

e9931f984dd1 qtnfmac: modify full Tx queue error reporting
3dd06cecb1b8 qtnfmac: enable registration of more mgmt frames
bf024645ac9d qtnfmac: drop nonexistent function declaration
c35c0d54a77d qtnfmac: modify full Tx queue recovery
db5c6d4a9b92 qtnfmac: advertise support of inactivity timeout

-- 
https://patchwork.kernel.org/patch/10032277/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
