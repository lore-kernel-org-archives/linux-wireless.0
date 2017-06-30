Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34959 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753107AbdF3Vh7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Jun 2017 17:37:59 -0400
MIME-Version: 1.0
In-Reply-To: <20170630190257.15016-1-f.fainelli@gmail.com>
References: <20170630190257.15016-1-f.fainelli@gmail.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Fri, 30 Jun 2017 23:37:53 +0200
Message-ID: <CACna6rwPRU7iGRxOym=LPpJu4_Lwr_cXTNduGyCnau9QKdhwPg@mail.gmail.com> (sfid-20170630_233825_297410_FE6F52FC)
Subject: Re: [PATCH] bcma: gpio: Correct number of GPIOs for BCM53573
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:BROADCOM SPECIFIC AMBA DRIVER (BCMA)"
        <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 June 2017 at 21:02, Florian Fainelli <f.fainelli@gmail.com> wrote:
> Broadcom BCM53573 SoCs actually have 32 GPIOs, and not 16.
>
> Fixes: 3f37ec79dd21 ("bcma: support BCM53573 series of wireless SoCs")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Looks good.
