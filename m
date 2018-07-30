Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36528 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbeG3Tap (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 15:30:45 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] ath10k: remove redundant pointers 'dev' and 'noa'
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180709123446.14796-1-colin.king@canonical.com>
References: <20180709123446.14796-1-colin.king@canonical.com>
To: Colin King <colin.king@canonical.com>
Cc: "David S . Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20180730175438.377C362203@smtp.codeaurora.org> (sfid-20180730_195534_723539_86754797)
Date: Mon, 30 Jul 2018 17:54:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin King <colin.king@canonical.com> wrote:

> Pointers dev and noa are being assigned but are never used hence they
> are redundant and can be removed.
> 
> Cleans up clang warnings:
> warning: variable 'dev' set but not used [-Wunused-but-set-variable]
> warning: variable 'noa' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

e6712aa1244f ath10k: remove redundant pointers 'dev' and 'noa'

-- 
https://patchwork.kernel.org/patch/10514521/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
