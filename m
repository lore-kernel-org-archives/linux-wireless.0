Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51270 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbeDYI02 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 04:26:28 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: qtnfmac: pearl: pcie: fix memory leak in qtnf_fw_work_handler
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180405154949.GA32223@embeddedor.com>
References: <20180405154949.GA32223@embeddedor.com>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-Id: <20180425082628.498886070B@smtp.codeaurora.org> (sfid-20180425_102708_199885_03EDABBD)
Date: Wed, 25 Apr 2018 08:26:28 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> In case memory resources for fw were succesfully allocated, release
> them before jumping to fw_load_fail.
> 
> Addresses-Coverity-ID: 1466092 ("Resource leak")
> Fixes: c3b2f7ca4186 ("qtnfmac: implement asynchronous firmware loading")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Patch applied to wireless-drivers-next.git, thanks.

376377004464 qtnfmac: pearl: pcie: fix memory leak in qtnf_fw_work_handler

-- 
https://patchwork.kernel.org/patch/10324855/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
