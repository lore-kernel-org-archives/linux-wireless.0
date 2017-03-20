Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36030 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753230AbdCTQpV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 12:45:21 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [3/3] mwifiex: wake system up when receives a wake irq
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1487917471-5501-3-git-send-email-jeffy.chen@rock-chips.com>
References: <1487917471-5501-3-git-send-email-jeffy.chen@rock-chips.com>
To: Jeffy Chen <jeffy.chen@rock-chips.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Brian Norris <briannorris@chromium.org>,
        Rajat Jain <rajatja@google.com>,
        Jeffy Chen <jeffy.chen@rock-chips.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>
Message-Id: <20170320164421.2735E60DAF@smtp.codeaurora.org> (sfid-20170320_174812_770936_35509E8D)
Date: Mon, 20 Mar 2017 16:44:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jeffy Chen <jeffy.chen@rock-chips.com> wrote:
> Currrently we are disabling this wake irq after receiving it. If this
> happens before we finish suspend and the pm event check is disabled,
> the system will continue suspending, and this irq would not work again.
> 
> We may need to abort system suspend to avoid that.
> 
> Signed-off-by: Jeffy Chen <jeffy.chen@rock-chips.com>

Patch applied to wireless-drivers-next.git, thanks.

ef7e07147425 mwifiex: wake system up when receives a wake irq

-- 
https://patchwork.kernel.org/patch/9589459/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
