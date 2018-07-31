Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55730 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbeGaIyJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 04:54:09 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] rsi: fix for low throughput issue
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1530794302-8833-2-git-send-email-sushant2k1513@gmail.com>
References: <1530794302-8833-2-git-send-email-sushant2k1513@gmail.com>
To: Sushant Kumar Mishra <sushant2k1513@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sanjay Kumar Konduri <sajay.konduri@redpinesignals.com>,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
Message-Id: <20180731071516.3C2F760714@smtp.codeaurora.org> (sfid-20180731_091538_117781_B99921E7)
Date: Tue, 31 Jul 2018 07:15:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sushant Kumar Mishra <sushant2k1513@gmail.com> wrote:

> From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> 
> observed low throughput rates during verification. This is because, QoS
> enable flag is overridden by sequence number in the data descriptor frame.
> Hence, added the fix for same.
> 
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> Signed-off-by: Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>

4 patches applied to wireless-drivers-next.git, thanks.

92e971238138 rsi: fix for low throughput issue
38709316d1c9 rsi: fix for 40MHZ connection issue.
4c837d8c9b0c rsi: fix for WoWLAN wakeup in security mode.
1d2194562112 rsi: optimize virtual interfaces

-- 
https://patchwork.kernel.org/patch/10508915/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
