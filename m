Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47770 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751887AbdITMfx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 08:35:53 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/2] qtnfmac: lock access to h/w in tx path
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170918122950.32612-2-sergey.matyukevich.os@quantenna.com>
References: <20170918122950.32612-2-sergey.matyukevich.os@quantenna.com>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Message-Id: <20170920123553.7121D6070F@smtp.codeaurora.org> (sfid-20170920_143557_336629_9C31B8A6)
Date: Wed, 20 Sep 2017 12:35:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> wrote:

> Fix tx path regression. Lock should be held when queuing packets
> to h/w fifos in order to properly handle configurations with
> multiple enabled interfaces.
> 
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

2 patches applied to wireless-drivers.git, thanks.

20da2ec06bfa qtnfmac: lock access to h/w in tx path
a715b3a0efe7 qtnfmac: cancel scans on wireless interface changes

-- 
https://patchwork.kernel.org/patch/9956607/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
