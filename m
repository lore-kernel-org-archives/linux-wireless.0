Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 2.mo69.mail-out.ovh.net ([178.33.251.80]:36377 "EHLO
        2.mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752363AbdBPIEn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Feb 2017 03:04:43 -0500
Received: from player696.ha.ovh.net (b7.ovh.net [213.186.33.57])
        by mo69.mail-out.ovh.net (Postfix) with ESMTP id 54E0C1AC53
        for <linux-wireless@vger.kernel.org>; Thu, 16 Feb 2017 08:25:52 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 16 Feb 2017 08:25:42 +0100
From: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Ming Lei <ming.lei@canonical.com>,
        "Luis R . Rodriguez" <mcgrof@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH 2/2] brcmfmac: don't warn user if loading firmware file
 with NVRAM fails
In-Reply-To: <CAHp75Vee+f5eH7DFWNcWFPcdoBf_63yQh7L71dLpNSmC5fXDww@mail.gmail.com>
References: <20170215222948.21030-1-zajec5@gmail.com>
 <20170215222948.21030-2-zajec5@gmail.com>
 <CAHp75Vee+f5eH7DFWNcWFPcdoBf_63yQh7L71dLpNSmC5fXDww@mail.gmail.com>
Message-ID: <de837236542d5b762d97e4d5a55cd589@milecki.pl> (sfid-20170216_090447_679785_7079056B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-02-16 02:19, Andy Shevchenko wrote:
> On Thu, Feb 16, 2017 at 12:29 AM, Rafał Miłecki <zajec5@gmail.com> 
> wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>> 
>> This isn't critical as we use platform NVRAM as fallback and it's very
>> common case of all Broadcom home routers. Thanks for the new firmware
>> loading function we can achieve this by simply passing FW_OPT_NO_WARN.
>> 
> 
> What kind of warning you are talking about?
> 
> On Intel Edison brcmfmac isn't backed up by NVRAM (there no such) and
> the platform is not ACPI-based. The warning might be crucial for
> debugging Wi-Fi issues on such platforms.

Sorry, I should have tried better with that commit message. V2 in a 
second.
