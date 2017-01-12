Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39270 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750720AbdALOq6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 09:46:58 -0500
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
Message-Id: <20170112144657.5677C61272@smtp.codeaurora.org> (sfid-20170112_154702_015936_B5A737F6)
Date: Thu, 12 Jan 2017 14:46:57 +0000 (UTC)
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

2 patches applied to wireless-drivers-next.git, thanks.

90ff71f95575 mwifiex: code rearrangement in pcie.c and sdio.c
045f0c1b5e26 mwifiex: get rid of global user_rmmod flag

-- 
https://patchwork.kernel.org/patch/9454491/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
