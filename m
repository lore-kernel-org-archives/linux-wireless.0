Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53908 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751510AbeDXRXA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 13:23:00 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [3/3] qtnfmac: add DFS offload support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180326133633.8771-4-sergey.matyukevich.os@quantenna.com>
References: <20180326133633.8771-4-sergey.matyukevich.os@quantenna.com>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Dmitry Lebed <dlebed@quantenna.com>,
        Dmitry Lebed <lebed.dmitry@gmail.com>
Message-Id: <20180424172259.CA72160F5F@smtp.codeaurora.org> (sfid-20180424_192303_966536_BC34580C)
Date: Tue, 24 Apr 2018 17:22:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> wrote:

> From: Dmitry Lebed <dlebed@quantenna.com>
> 
> DFS offload support implemented:
> - DFS_OFFLOAD feature is advertised depending on HW capabilities
> - CAC_STARTED event forwarding from HW implemented
> - start_radar_detection() callback now returning -ENOTSUPP
>   if DFS_OFFLOAD is enabled
> 
> Signed-off-by: Dmitry Lebed <dlebed@quantenna.com>

Patch applied to wireless-drivers-next.git, thanks.

fbb93020b89b qtnfmac: add DFS offload support

-- 
https://patchwork.kernel.org/patch/10307827/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
