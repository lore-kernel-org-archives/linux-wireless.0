Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44630 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751691AbcL3LYK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 06:24:10 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] mwifiex: code rearrangement in pcie.c and sdio.c
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1480517537-9920-1-git-send-email-akarwar@marvell.com>
References: <1480517537-9920-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20161230112409.DD2796147D@smtp.codeaurora.org> (sfid-20161230_122413_740771_DF61EAFC)
Date: Fri, 30 Dec 2016 11:24:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> Next patch in this series is going to use mwifiex_read_reg() in remove
> handlers. The changes here are prerequisites to avoid forward
> declarations.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Patch 2 doesn't apply.

fatal: sha1 information is lacking or useless (drivers/net/wireless/marvell/mwifiex/pcie.c).
Applying: mwifiex: get rid of global user_rmmod flag
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0001 mwifiex: get rid of global user_rmmod flag

2 patches set to Changes Requested.

9454491 [1/2] mwifiex: code rearrangement in pcie.c and sdio.c
9454493 [2/2] mwifiex: get rid of global user_rmmod flag

-- 
https://patchwork.kernel.org/patch/9454491/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
