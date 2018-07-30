Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37492 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727667AbeG3Tdl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 15:33:41 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] ath6kl: remove redundant variables netlen, orig_buf,
 orig_len, dropped and stats
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180709131720.6668-1-colin.king@canonical.com>
References: <20180709131720.6668-1-colin.king@canonical.com>
To: Colin King <colin.king@canonical.com>
Cc: "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20180730175733.B6B8B60B15@smtp.codeaurora.org> (sfid-20180730_195743_802288_68773FEC)
Date: Mon, 30 Jul 2018 17:57:33 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin King <colin.king@canonical.com> wrote:

> Variables netlen, orig_buf, orig_len, dropped and stats are assigned values
> but are never used hence they are redundant and can be removed.
> 
> Cleans up clang warnings:
> warning: variable 'netlen' set but not used [-Wunused-but-set-variable]
> warning: variable 'orig_buf' set but not used [-Wunused-but-set-variable]
> warning: variable 'orig_len' set but not used [-Wunused-but-set-variable]
> warning: variable 'dropped' set but not used [-Wunused-but-set-variable]
> warning: variable 'stats' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

619c9700a8fe ath6kl: remove redundant variables netlen, orig_buf, orig_len, dropped and stats

-- 
https://patchwork.kernel.org/patch/10514565/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
