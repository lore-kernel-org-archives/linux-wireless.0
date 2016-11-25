Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59286 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750850AbcKYJuZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Nov 2016 04:50:25 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] mwifiex: cleanup wake-IRQ handling if suspend fails
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1479489205-30288-1-git-send-email-akarwar@marvell.com>
References: <1479489205-30288-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <rajatja@google.com>,
        <briannorris@google.com>, <dmitry.torokhov@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20161125095019.4BC32613D3@smtp.codeaurora.org> (sfid-20161125_105048_958496_87688B1A)
Date: Fri, 25 Nov 2016 09:50:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> From: Brian Norris <briannorris@chromium.org>
> 
> We don't want to leave the wake IRQ enabled.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

2 patches applied to wireless-drivers-next.git, thanks.

d96e39270ba5 mwifiex: cleanup wake-IRQ handling if suspend fails
b9da4d223bda mwifiex: avoid double-disable_irq() race

-- 
https://patchwork.kernel.org/patch/9437097/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
