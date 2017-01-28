Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54838 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750728AbdA1HL2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Jan 2017 02:11:28 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wlcore: print the sdio buffer after reading it
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170126153513.25007-1-guym@ti.com>
References: <20170126153513.25007-1-guym@ti.com>
To: Guy Mishol <guym@ti.com>
Cc: <linux-wireless@vger.kernel.org>, Guy Mishol <guym@ti.com>
Message-Id: <20170128071127.F0F8560A51@smtp.codeaurora.org> (sfid-20170128_081203_611444_D083D33B)
Date: Sat, 28 Jan 2017 07:11:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Guy Mishol <guym@ti.com> wrote:
> fix an issue where we printed the sdio buffer before
> actually read it.
> 
> Signed-off-by: Guy Mishol <guym@ti.com>

Patch applied to wireless-drivers-next.git, thanks.

64ad08605e84 wlcore: print the sdio buffer after reading it

-- 
https://patchwork.kernel.org/patch/9539423/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
