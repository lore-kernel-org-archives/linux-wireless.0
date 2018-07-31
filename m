Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56770 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbeGaI5l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 04:57:41 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] ipw2x00: remove redundant variables len, ret,
 reason and crypt
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180711071212.3018-1-colin.king@canonical.com>
References: <20180711071212.3018-1-colin.king@canonical.com>
To: Colin King <colin.king@canonical.com>
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Message-Id: <20180731071847.4839760397@smtp.codeaurora.org> (sfid-20180731_091900_324051_155ACDD4)
Date: Tue, 31 Jul 2018 07:18:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Variables len, ret, reason and crypt are assigned values that
> are never read, hence they are redundant and can be removed.
> 
> Note: For the variable ret, a return code is being assigned, but
> this is not returned and 0 is currently being returned, I believe
> this is OK.
> 
> Cleans up clang warnings:
> warning: variable 'len' set but not used [-Wunused-but-set-variable]
> variable 'ret' set but not used [-Wunused-but-set-variable]
> warning: variable 'reason' set but not used [-Wunused-but-set-variable]
> warning: variable 'crypt' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

0e139e97f58e ipw2x00: remove redundant variables len, ret, reason and crypt

-- 
https://patchwork.kernel.org/patch/10518849/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
