Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39930 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750983AbdALOt5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 09:49:57 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/5] mwifiex: get rid of mwifiex_do_flr wrapper
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1481724651-30397-1-git-send-email-akarwar@marvell.com>
References: <1481724651-30397-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20170112144957.24F0A6120C@smtp.codeaurora.org> (sfid-20170112_155002_238155_EF3E13A2)
Date: Thu, 12 Jan 2017 14:49:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> This patch gets rid of mwifiex_do_flr. We will call
> mwifiex_shutdown_sw() and mwifiex_reinit_sw() directly.
> These two general purpose functions will be useful for
> sdio card reset handler.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

5 patches applied to wireless-drivers-next.git, thanks.

8750ab6236b0 mwifiex: get rid of mwifiex_do_flr wrapper
ec750f1082d7 mwifiex: cleanup in PCIe flr code path
c742e623e941 mwifiex: sdio card reset enhancement
a7513a4fa919 mwifiex: get rid of __mwifiex_sdio_remove helper
cc75c577806a mwifiex: get rid of global save_adapter and sdio_work

-- 
https://patchwork.kernel.org/patch/9474231/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
