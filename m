Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48152 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbeIDMkV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 08:40:21 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] rtl8xxxu: Add rtl8188ctv support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180830140541.31964-1-mamlinav@gmail.com>
References: <20180830140541.31964-1-mamlinav@gmail.com>
To: Aleksei Mamlin <mamlinav@gmail.com>
Cc: Jes Sorensen <Jes.Sorensen@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aleksei Mamlin <mamlinav@gmail.com>
Message-Id: <20180904081619.8E2F060708@smtp.codeaurora.org> (sfid-20180904_101635_652264_737E0B9D)
Date: Tue,  4 Sep 2018 08:16:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Aleksei Mamlin <mamlinav@gmail.com> wrote:

> The Realtek rtl8188ctv (0x0bda:0x018a) is a highly integrated single-chip
> WLAN USB2.0 network interface controller.
> 
> Currently rtl8188ctv is supported by rtlwifi driver.
> It is similar to the rtl8188cus(0x0bda:0x818a) and uses the same config.
> 
> Signed-off-by: Aleksei Mamlin <mamlinav@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

514502c3a70b rtl8xxxu: Add rtl8188ctv support

-- 
https://patchwork.kernel.org/patch/10581745/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
