Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52938 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752161AbeB0QRD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 11:17:03 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wireless: zd1211rw: remove redundant assignment of pointer 'q'
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180130182537.5580-1-colin.king@canonical.com>
References: <20180130182537.5580-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20180227161702.81FE4607E5@smtp.codeaurora.org> (sfid-20180227_171721_572775_7A040634)
Date: Tue, 27 Feb 2018 16:17:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Pointer q is initialized and then almost immediately afterwards being
> re-assigned the same value. Remove the second redundant assignment.
> 
> Cleans up clang warning:
> drivers/net/wireless/zydas/zd1211rw/zd_mac.c:503:23: warning: Value
> stored to 'q' during its initialization is never read
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

76d1f95983a0 wireless: zd1211rw: remove redundant assignment of pointer 'q'

-- 
https://patchwork.kernel.org/patch/10192195/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
