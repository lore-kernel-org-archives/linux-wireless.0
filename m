Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43492 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754394AbdDMOFs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 10:05:48 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: Fix invalid port issue
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1491281188-6471-1-git-send-email-gbhat@marvell.com>
References: <1491281188-6471-1-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20170413140547.E7A3460D70@smtp.codeaurora.org> (sfid-20170413_160627_512975_E3CEC95E)
Date: Thu, 13 Apr 2017 14:05:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:
> We have to use start port, for TX/RX of single packet,
> instead of current aggregating port. This will fix SDIO
> CMD53(TX/RX) returning -ETIMEDOUT and halting the data path.
> 
> Fixes: 0cb52aac4d19 ("mwifiex: do not set multiport flag for tx/rx single packet")
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

ecd7eb7c2bcf mwifiex: Fix invalid port issue

-- 
https://patchwork.kernel.org/patch/9660845/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
