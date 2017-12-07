Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34288 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932484AbdLGNQe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 08:16:34 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl818x: remove redundant check for cck_power > 15
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171114170145.3987-1-colin.king@canonical.com>
References: <20171114170145.3987-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20171207131633.AC4D560913@smtp.codeaurora.org> (sfid-20171207_141804_694757_AEF6F3D2)
Date: Thu,  7 Dec 2017 13:16:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> cck_poweri cannot be greated than 15 as is derived from the bottom 4 bits
> from riv->channels[channel - 1].hw_value & 0xf.  Hence the check for it
> being greater than 15 is redundant and can be removed.
> 
> Detected by CoverityScan, CID#744303 ("Logically dead code")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

45d9d1a12efa rtlwifi: rtl818x: remove redundant check for cck_power > 15

-- 
https://patchwork.kernel.org/patch/10057925/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
