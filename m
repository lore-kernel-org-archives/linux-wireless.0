Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36720 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751379AbdGRSc1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Jul 2017 14:32:27 -0400
Subject: Re: [PATCH] bcma: gpio: Correct number of GPIOs for BCM53573
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:BROADCOM SPECIFIC AMBA DRIVER (BCMA)"
        <linux-wireless@vger.kernel.org>
References: <20170630190257.15016-1-f.fainelli@gmail.com>
 <CACna6rwPRU7iGRxOym=LPpJu4_Lwr_cXTNduGyCnau9QKdhwPg@mail.gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7481f7ab-6f09-a012-5609-cc803f316961@gmail.com> (sfid-20170718_203244_533646_2F6D624B)
Date: Tue, 18 Jul 2017 11:32:22 -0700
MIME-Version: 1.0
In-Reply-To: <CACna6rwPRU7iGRxOym=LPpJu4_Lwr_cXTNduGyCnau9QKdhwPg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/30/2017 02:37 PM, Rafał Miłecki wrote:
> On 30 June 2017 at 21:02, Florian Fainelli <f.fainelli@gmail.com> wrote:
>> Broadcom BCM53573 SoCs actually have 32 GPIOs, and not 16.
>>
>> Fixes: 3f37ec79dd21 ("bcma: support BCM53573 series of wireless SoCs")
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Looks good.

Is Kalle still on vacation, I suppose he is?
-- 
Florian
