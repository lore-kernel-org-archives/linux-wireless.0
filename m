Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37888 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752711AbdHXJ5E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 05:57:04 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [RESEND,v12,7/8] wireless: ipw2200: Replace PCI pool old API
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170823071651.7865-1-romain.perier@collabora.com>
References: <20170823071651.7865-1-romain.perier@collabora.com>
To: Romain Perier <romain.perier@collabora.com>
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Romain Perier <romain.perier@collabora.com>
Message-Id: <20170824095703.AF6EF606DD@smtp.codeaurora.org> (sfid-20170824_115725_017608_189197A9)
Date: Thu, 24 Aug 2017 09:57:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Romain Perier <romain.perier@collabora.com> wrote:

> The PCI pool API is deprecated. This commit replaces the PCI pool old
> API by the appropriate function with the DMA pool API.
> 
> Signed-off-by: Romain Perier <romain.perier@collabora.com>
> Reviewed-by: Peter Senna Tschudin <peter.senna@collabora.com>
> Acked-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

28b75415ad19 wireless: ipw2200: Replace PCI pool old API

-- 
https://patchwork.kernel.org/patch/9916775/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
