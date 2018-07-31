Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56958 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbeGaI6W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 04:58:22 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] iwlegacy: remove several redundant variables
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180711074253.4192-1-colin.king@canonical.com>
References: <20180711074253.4192-1-colin.king@canonical.com>
To: Colin King <colin.king@canonical.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20180731071927.F3E2460376@smtp.codeaurora.org> (sfid-20180731_091942_818618_4116C70A)
Date: Tue, 31 Jul 2018 07:19:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Variables id, unicast, write, conf, a_band, accum_tx and ucode are
> assigned a value but it is never read, hence they are redundant and
> can be removed.
> 
> Cleans up clang warnings:
> warning: variable 'id' set but not used [-Wunused-but-set-variable]
> warning: variable 'unicast' set but not used [-Wunused-but-set-variable]
> warning: variable 'write' set but not used [-Wunused-but-set-variable]
> warning: variable 'conf' set but not used [-Wunused-but-set-variable]
> warning: variable 'a_band' set but not used [-Wunused-but-set-variable]
> warning: variable 'tx' set but not used [-Wunused-but-set-variable]
> warning: variable 'accum_tx' set but not used [-Wunused-but-set-variable]
> warning: variable 'ucode' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

454127ad36fb iwlegacy: remove several redundant variables

-- 
https://patchwork.kernel.org/patch/10519029/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
