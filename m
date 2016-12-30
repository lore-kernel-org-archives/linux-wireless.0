Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44778 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752624AbcL3LZU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 06:25:20 -0500
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
Message-Id: <20161230112519.EF42F6145C@smtp.codeaurora.org> (sfid-20161230_122523_374291_A0B7C527)
Date: Fri, 30 Dec 2016 11:25:19 +0000 (UTC)
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

Patch 3 doesn't apply.

fatal: sha1 information is lacking or useless (drivers/net/wireless/marvell/mwifiex/sdio.c).
Applying: mwifiex: sdio card reset enhancement
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0001 mwifiex: sdio card reset enhancement

5 patches set to Changes Requested.

9474231 [1/5] mwifiex: get rid of mwifiex_do_flr wrapper
9474241 [2/5] mwifiex: cleanup in PCIe flr code path
9474235 [3/5] mwifiex: sdio card reset enhancement
9474233 [4/5] mwifiex: get rid of __mwifiex_sdio_remove helper
9474237 [5/5] mwifiex: get rid of global save_adapter and sdio_work

-- 
https://patchwork.kernel.org/patch/9474231/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
