Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53620 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932261AbcKQR0N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 12:26:13 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v7] mwifiex: parse device tree node for PCIe
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1479215662-631-1-git-send-email-akarwar@marvell.com>
References: <1479215662-631-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20161117123920.D085B615BD@smtp.codeaurora.org> (sfid-20161117_182618_870978_78C766D6)
Date: Thu, 17 Nov 2016 12:39:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> This patch derives device tree node from pcie bus layer framework.
> Device tree bindings file has been renamed(marvell-sd8xxx.txt ->
> marvell-8xxx.txt) to accommodate PCIe changes.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Rajat Jain <rajatja@google.com>
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

You should CC the device tree list when making changes to the bindings.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9429723/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
