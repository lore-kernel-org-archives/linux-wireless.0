Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39200 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751413AbeD3KeZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 06:34:25 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rsi_91x: fix uninitialized variable
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180426131324.GA982@embeddedor.com>
References: <20180426131324.GA982@embeddedor.com>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-Id: <20180430103424.D492960807@smtp.codeaurora.org> (sfid-20180430_123441_491420_1992E708)
Date: Mon, 30 Apr 2018 10:34:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> There is a potential execution path in which variable ret is returned
> without being properly initialized previously.
> 
> Fix this by storing the value returned by function
> rsi_usb_master_reg_write into _ret_.
> 
> Addresses-Coverity-ID: 1468407 ("Uninitialized scalar variable")
> Fixes: 16d3bb7b2f37 ("rsi: disable fw watchdog timer during reset")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Patch applied to wireless-drivers-next.git, thanks.

48c6b5c9c118 rsi_91x: fix uninitialized variable

-- 
https://patchwork.kernel.org/patch/10365985/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
