Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [12.131.200.82] ([12.131.200.82]:46913 "EHLO
        fm-smtp01.quantenna.com" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1750816AbeFABLs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 May 2018 21:11:48 -0400
Subject: Re: [PATCH 0/6] qtnfmac: enable more features
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        linux-wireless@vger.kernel.org
Cc: Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
References: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <784f8aa4-8c64-043f-eef7-a56453b87531@quantenna.com> (sfid-20180601_031153_011276_55348550)
Date: Thu, 31 May 2018 18:08:58 -0700
MIME-Version: 1.0
In-Reply-To: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/31/2018 02:10 AM, Sergey Matyukevich wrote:
> Hello Kalle and all,
> 
> Here is the next update for qtnfmac driver which enables more wireless
> features. The major changes include the following items:
> - cfg80211 power management callback
> - net_device_ops set MAC addr callback
> - advanced scan features: multiple SSIDs and randomized source MACs
> - basic WoWLAN support: disconnect/magic/pattern triggers
>    -- not yet: PCIe backend suspend/resume, reporting wakeup reason
> 
> Regards,
> Sergey

All patches except for mine
Reviewed-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
