Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54094 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752076AbdKHMwu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Nov 2017 07:52:50 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: orinoco_usb: remove redundant pointer dev
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171103134528.8415-1-colin.king@canonical.com>
References: <20171103134528.8415-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20171108125249.B823E607C7@smtp.codeaurora.org> (sfid-20171108_135308_404379_73C9231F)
Date: Wed,  8 Nov 2017 12:52:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The pointer dev is assigned but never read, hence it is redundant
> and can be removed. Cleans up clang warning:
> 
> drivers/net/wireless/intersil/orinoco/orinoco_usb.c:1468:2: warning:
> Value stored to 'dev' is never read
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

9b741b2a3148 orinoco_usb: remove redundant pointer dev

-- 
https://patchwork.kernel.org/patch/10040113/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
