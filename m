Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36636 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdBXLEV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 06:04:21 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Jeffy Chen <jeffy.chen@rock-chips.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Brian Norris <briannorris@chromium.org>,
        Rajat Jain <rajatja@google.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH 3/3] mwifiex: wake system up when receives a wake irq
References: <1487917471-5501-1-git-send-email-jeffy.chen@rock-chips.com>
        <1487917471-5501-3-git-send-email-jeffy.chen@rock-chips.com>
Date: Fri, 24 Feb 2017 13:01:42 +0200
In-Reply-To: <1487917471-5501-3-git-send-email-jeffy.chen@rock-chips.com>
        (Jeffy Chen's message of "Fri, 24 Feb 2017 14:24:31 +0800")
Message-ID: <87d1e726p5.fsf@codeaurora.org> (sfid-20170224_120523_440964_56733EE0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jeffy Chen <jeffy.chen@rock-chips.com> writes:

> Currrently we are disabling this wake irq after receiving it. If this
> happens before we finish suspend and the pm event check is disabled,
> the system will continue suspending, and this irq would not work again.
>
> We may need to abort system suspend to avoid that.
>
> Signed-off-by: Jeffy Chen <jeffy.chen@rock-chips.com>

I only see patch 3 in patchwork. Where are patches 1 and 2?

-- 
Kalle Valo
