Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0054.outbound.protection.outlook.com ([104.47.33.54]:10112
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751275AbeDEQbT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Apr 2018 12:31:19 -0400
Date: Thu, 5 Apr 2018 19:31:02 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] qtnfmac: pearl: pcie: fix memory leak in
 qtnf_fw_work_handler
Message-ID: <20180405163100.cuaedftds47pxdrn@bars> (sfid-20180405_183140_267435_26F24731)
References: <20180405154949.GA32223@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180405154949.GA32223@embeddedor.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Gustavo,

> In case memory resources for fw were succesfully allocated, release
> them before jumping to fw_load_fail.
> 
> Addresses-Coverity-ID: 1466092 ("Resource leak")
> Fixes: c3b2f7ca4186 ("qtnfmac: implement asynchronous firmware loading")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c | 4 ++++
>  1 file changed, 4 insertions(+)

Thanks for the patch!

Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Regards,
Sergey
