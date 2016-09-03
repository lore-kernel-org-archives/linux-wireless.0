Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57187 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752499AbcICKH3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 06:07:29 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] mwifiex: correct aid value during tdls setup
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1470754246-635-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20160903100607.688F9612C0@smtp.codeaurora.org> (sfid-20160903_120732_973932_7EF0605E)
Date: Sat,  3 Sep 2016 10:06:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> AID gets updated during TDLS setup, but modified value isn't reflected
> in "priv->assoc_rsp_buf". This causes TDLS setup failure. The problem is
> fixed here.
> 
> Fixes: 4aff53ef18e4a4 ("mwifiex: parsing aid while receiving..")
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

Thanks, 3 patches applied to wireless-drivers-next.git:

b64db1b252e9 mwifiex: correct aid value during tdls setup
41960b4dfdfc mwifiex: add CHAN_REGION_CFG command
72539799104d mwifiex: add custom regulatory domain support

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9271429/
