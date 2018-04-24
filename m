Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57148 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750826AbeDXRZs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 13:25:48 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/7] rsi: disable fw watchdog timer during reset
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1523372657-6067-2-git-send-email-siva8118@gmail.com>
References: <1523372657-6067-2-git-send-email-siva8118@gmail.com>
To: Siva Rebbagondla <siva8118@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sushant Mishra <sushant.mishra@redpinesignals.com>
Message-Id: <20180424172547.B959D6090E@smtp.codeaurora.org> (sfid-20180424_192609_614046_FC11ADF8)
Date: Tue, 24 Apr 2018 17:25:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Siva Rebbagondla <siva8118@gmail.com> wrote:

> From: Amitkumar Karwar <amit.karwar@redpinesignals.com>
> 
> Firmware's watchdog timer should be disabled as a part of reset
> sequence. This change fixes a firmware hang issue observed during
> stress tests.
> 
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

7 patches applied to wireless-drivers-next.git, thanks.

16d3bb7b2f37 rsi: disable fw watchdog timer during reset
8c1475bdfc3a rsi: device bootup parameter configuration
cbbfdd6c700f rsi: use appropriate interface for power save configuration
a55e50f0672e rsi: increase max supported aggregation subframes
3334306a086e rsi: parse TID from data frame correctly
1e9c410f26a2 rsi: enable power save by default for coex
f0b147b8f1d2 rsi: advertise 5GHz support based on device capability

-- 
https://patchwork.kernel.org/patch/10333303/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
