Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53821 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753297AbcINRAw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 13:00:52 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] mwifiex: handle error if IRQ request fails in
 mwifiex_sdio_of()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1473418678-14794-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160914170024.B4D4361AD3@smtp.codeaurora.org> (sfid-20160914_190120_284502_987A0D01)
Date: Wed, 14 Sep 2016 17:00:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> When this failure occurs, we will clear card->plt_wake_cfg so that
> device would initialize without wake up on external interrupt feature.
> This feature specific code in suspend and resume handlers will be
> skipped.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

6b03144d93fc mwifiex: handle error if IRQ request fails in mwifiex_sdio_of()

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9322927/
