Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33340 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936904AbdEXOGc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 10:06:32 -0400
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
Message-Id: <20170524140631.CAA0C60D74@smtp.codeaurora.org> (sfid-20170524_160636_982413_6764C0D1)
Date: Wed, 24 May 2017 14:06:31 +0000 (UTC)
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

Patch applied to wireless-drivers-next.git, thanks.

98f44cb0655c qtnfmac: introduce new FullMAC driver for Quantenna chipsets

-- 
https://patchwork.kernel.org/patch/9723191/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
