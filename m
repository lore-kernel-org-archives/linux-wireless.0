Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37720 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750710AbdIREwR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2017 00:52:17 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 0/2] qtnfmac: misc fixes intended for 4.14
References: <20170915115300.12719-1-sergey.matyukevich.os@quantenna.com>
Date: Mon, 18 Sep 2017 07:52:13 +0300
In-Reply-To: <20170915115300.12719-1-sergey.matyukevich.os@quantenna.com>
        (Sergey Matyukevich's message of "Fri, 15 Sep 2017 14:52:58 +0300")
Message-ID: <87377kmww2.fsf@purkki.adurom.net> (sfid-20170918_065223_657732_5AAF1A63)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> Here are two patches intended for 4.14. The first patch fixes tx path
> regression. Lock should be held when queuing packets to h/w fifos in order to
> properly handle configurations with two enabled interfaces or multiple enabled
> mbss. The second patch fixes scan issues addressing a review comment
> from K.Valo regarding pending active scans upon device removal.
>
> Regards,
> Sergey
>
> Sergey Matyukevich (2):
>
> qtnfmac: lock access to h/w in tx path
> qtnfmac: abort scans on wireless interface changes

There was a problem patchwork.kernel.org over the weekend, but it should
be fixed now. Unfortunately your patches didn't make it to patchwork, so
please resend.

https://patchwork.kernel.org/project/linux-wireless/list/?state=*

-- 
Kalle Valo
