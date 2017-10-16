Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0066.outbound.protection.outlook.com ([104.47.38.66]:61952
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752678AbdJPTWW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 15:22:22 -0400
Subject: Re: [PATCH 0/8] qtnfmac: misc small features and fixes
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        linux-wireless@vger.kernel.org
Cc: Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
References: <20171015205327.9966-1-sergey.matyukevich.os@quantenna.com>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <847921c8-cae7-2a95-f469-58885986d932@quantenna.com> (sfid-20171016_212312_818655_837E8FA4)
Date: Mon, 16 Oct 2017 12:22:14 -0700
MIME-Version: 1.0
In-Reply-To: <20171015205327.9966-1-sergey.matyukevich.os@quantenna.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/15/2017 01:53 PM, Sergey Matyukevich wrote:
> Hello Kalle, Igor, and all
> 
> This patch series includes a number of small features and fixes
> for qtnfmac driver.
> 
> Igor Mitsyanko (1):
>   qtnfmac: advertise support of inactivity timeout
> 
> Sergey Matyukevich (4):
>   qtnfmac: modify full Tx queue error reporting
>   qtnfmac: enable registration of more mgmt frames
>   qtnfmac: drop nonexistent function declaration
>   qtnfmac: modify full Tx queue recovery
> 
> 
>   drivers/net/wireless/quantenna/qtnfmac/cfg80211.c            |   17 +++++++++++++++--
>   drivers/net/wireless/quantenna/qtnfmac/commands.c            |    5 +++--
>   drivers/net/wireless/quantenna/qtnfmac/core.c                |   27 +++++++++++++++++++++++++++
>   drivers/net/wireless/quantenna/qtnfmac/core.h                |    4 +---
>   drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c          |   15 +++++++++------
>   drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h |    1 +
>   drivers/net/wireless/quantenna/qtnfmac/qlink.h               |   11 ++++++++++-
>   7 files changed, 66 insertions(+), 14 deletions(-)
> 

Reviewed-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
