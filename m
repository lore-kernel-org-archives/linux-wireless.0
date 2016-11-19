Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45532 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbcKSHL7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Nov 2016 02:11:59 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v8] mwifiex: parse device tree node for PCIe
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1479472624-22340-1-git-send-email-akarwar@marvell.com>
References: <1479472624-22340-1-git-send-email-akarwar@marvell.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>, <devicetree@vger.kernel.org>,
        Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <20161119071158.B7E5D61482@smtp.codeaurora.org> (sfid-20161119_081222_941591_39ECF813)
Date: Sat, 19 Nov 2016 07:11:58 +0000 (UTC)
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
> Acked-by: Rob Herring <robh@kernel.org>

Patch applied to wireless-drivers-next.git, thanks.

6b4480d109b0 mwifiex: parse device tree node for PCIe

-- 
https://patchwork.kernel.org/patch/9436393/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
