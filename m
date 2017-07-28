Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49840 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751895AbdG1Oul (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:50:41 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] mwifiex: uninit wakeup info in the error handling
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1499327728-25388-1-git-send-email-jeffy.chen@rock-chips.com>
References: <1499327728-25388-1-git-send-email-jeffy.chen@rock-chips.com>
To: Jeffy Chen <jeffy.chen@rock-chips.com>
Cc: linux-wireless@vger.kernel.org, akarwar@marvell.com,
        briannorris@google.com, Jeffy Chen <jeffy.chen@rock-chips.com>,
        Xinming Hu <huxm@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-kernel@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        netdev@vger.kernel.org
Message-Id: <20170728145040.C94676095E@smtp.codeaurora.org> (sfid-20170728_165149_188321_F3AF0261)
Date: Fri, 28 Jul 2017 14:50:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jeffy Chen <jeffy.chen@rock-chips.com> wrote:

> We inited wakeup info at the beginning of mwifiex_add_card, so we need
> to uninit it in the error handling.
> 
> It's much the same as what we did in:
> 36908c4 mwifiex: uninit wakeup info when removing device
> 
> Signed-off-by: Jeffy Chen <jeffy.chen@rock-chips.com>
> Reviewed-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

f101d9649c42 mwifiex: uninit wakeup info in the error handling

-- 
https://patchwork.kernel.org/patch/9827589/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
