Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41448 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750755AbdESH6Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 03:58:25 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath9k: remove unnecessary code
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170509130430.GA22190@embeddedgus>
References: <20170509130430.GA22190@embeddedgus>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
CC: <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <e681a4945fe04738af9a9f58263f059d@euamsexm01a.eu.qualcomm.com> (sfid-20170519_095904_273409_A25305FE)
Date: Fri, 19 May 2017 09:58:17 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gustavo A. R. Silva" <garsilva@embeddedor.com> wrote:
> The array field eeprom_data in struct th9k_platform_data
> is a fixed size array so it can never be NULL.
> 
> Addresses-Coverity-ID: 1364903
> Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>

Patch applied to ath-next branch of ath.git, thanks.

641c1f4ab7f6 ath9k: remove unnecessary code

-- 
https://patchwork.kernel.org/patch/9717873/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
