Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35746 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750803AbdELPSz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 11:18:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v6] qtnfmac: introduce new FullMAC driver for Quantenna chipsets
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170511215101.15356-1-igor.mitsyanko.os@quantenna.com>
References: <20170511215101.15356-1-igor.mitsyanko.os@quantenna.com>
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Dmitrii Lebed <dlebed@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Bindu Therthala <btherthala@quantenna.com>,
        Huizhao Wang <hwang@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Message-Id: <20170512151854.6F16A60953@smtp.codeaurora.org> (sfid-20170512_171900_178500_DCE677CA)
Date: Fri, 12 May 2017 15:18:54 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Igor Mitsyanko <igor.mitsyanko.os@quantenna.com> wrote:
> From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> 
> This patch adds support for new FullMAC WiFi driver for Quantenna
> QSR10G chipsets.
> 
> QSR10G (aka Pearl) is Quantenna's 8x8, 160M, 11ac offering.
> QSR10G supports 2 simultaneous WMACs - one 5G and one 2G.
> 5G WMAC supports 160M, 8x8 configuration. FW supports
> up to 8 concurrent virtual interfaces on each WMAC.
> 
> Patch introduces 2 new drivers:
> - qtnfmac.ko for interfacing with kernel wireless core
> - qtnfmac_pearl_pcie.ko for interfacing with hardware over PCIe interface
> 
> Signed-off-by: Dmitrii Lebed <dlebed@quantenna.com>
> Signed-off-by: Sergei Maksimenko <smaksimenko@quantenna.com>
> Signed-off-by: Sergey Matyukevich <smatyukevich@quantenna.com>
> Signed-off-by: Bindu Therthala <btherthala@quantenna.com>
> Signed-off-by: Huizhao Wang <hwang@quantenna.com>
> Signed-off-by: Kamlesh Rath <krath@quantenna.com>
> Signed-off-by: Avinash Patil <avinashp@quantenna.com>
> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

I applied this now to the pending branch so that the kbuild bot can do it's
magic:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/log/?h=pending

If all goes smooth I'm planning to apply this to wireless-drivers-next master
branch within the next week or two. So if there's something still to comment
about this driver better speak up now. And unless it's something really
critical any changes can be done as followup patches. I don't want to delay
this any longer.

-- 
https://patchwork.kernel.org/patch/9723191/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
