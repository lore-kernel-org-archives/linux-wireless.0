Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55658 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752277AbdKHMyb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Nov 2017 07:54:31 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: zd1201: remove unused variable framelen
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171107185630.7791-1-colin.king@canonical.com>
References: <20171107185630.7791-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20171108125430.B983F60261@smtp.codeaurora.org> (sfid-20171108_135449_151000_45BC0EEE)
Date: Wed,  8 Nov 2017 12:54:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Variable framelen is assigned but never read, hence it is redundant
> and can be removed. Cleans up clang warning:
> 
> drivers/net/wireless/zydas/zd1201.c:234:3: warning: Value stored
> to 'framelen' is never read
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

03e40f1e7680 zd1201: remove unused variable framelen

-- 
https://patchwork.kernel.org/patch/10047145/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
