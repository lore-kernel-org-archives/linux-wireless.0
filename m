Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57452 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbeGaI7Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 04:59:24 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] ray_cs: remove redundant pointer 'p'
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180720180740.21018-1-colin.king@canonical.com>
References: <20180720180740.21018-1-colin.king@canonical.com>
To: Colin King <colin.king@canonical.com>
Cc: "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20180731072029.1243B607BD@smtp.codeaurora.org> (sfid-20180731_092055_107389_95839BF2)
Date: Tue, 31 Jul 2018 07:20:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Pointer 'p' is being assigned but is never used hence it is
> redundant and can be removed. Also re-work if statement to remove
> redundant assignment of p.
> 
> Cleans up clang warning:
> warning: variable 'p' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

f21bcefcf91c ray_cs: remove redundant pointer 'p'

-- 
https://patchwork.kernel.org/patch/10538143/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
