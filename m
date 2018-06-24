Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39710 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751666AbeFXRBI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Jun 2018 13:01:08 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] Revert "mwifiex: handle race during mwifiex_usb_disconnect"
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1527849680-31445-1-git-send-email-gbhat@marvell.com>
References: <1527849680-31445-1-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20180624170107.C9EDB605A5@smtp.codeaurora.org> (sfid-20180624_190111_874465_0D1824C5)
Date: Sun, 24 Jun 2018 17:01:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:

> This reverts commit b817047ae70c0bd67b677b65d0d69d72cd6e9728.
> 
> We have a better fix for this issue, which will be sent on top
> of this revert.
> 
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

2 patches applied to wireless-drivers.git, thanks.

7e58e741c001 Revert "mwifiex: handle race during mwifiex_usb_disconnect"
f8c095f67962 mwifiex: handle race during mwifiex_usb_disconnect

-- 
https://patchwork.kernel.org/patch/10442949/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
