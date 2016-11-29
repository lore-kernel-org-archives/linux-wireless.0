Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33805 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756904AbcK2MaH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 07:30:07 -0500
Received: by mail-oi0-f67.google.com with SMTP id m75so18096718oig.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Nov 2016 04:30:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <a763eacb-edd9-e551-dad7-456fac580f14@broadcom.com>
References: <1479896731-5091-1-git-send-email-arend.vanspriel@broadcom.com>
 <CACna6rxszuTY3g=brCkWmwX7mT0-ptjpQMG+YTrPzfoc=dJvcA@mail.gmail.com> <a763eacb-edd9-e551-dad7-456fac580f14@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Tue, 29 Nov 2016 13:30:06 +0100
Message-ID: <CACna6rwF+0g3FyiExJr0yf92YDQWbiCm8EGwSNFWR_8G9vC6cg@mail.gmail.com> (sfid-20161129_133011_068544_829BA18D)
Subject: Re: [PATCH 00/12] brcmfmac: scheduled scan cleanup and chip support
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 November 2016 at 10:58, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 29-11-2016 8:37, Rafa=C5=82 Mi=C5=82ecki wrote:
>> On 23 November 2016 at 11:25, Arend van Spriel
>> <arend.vanspriel@broadcom.com> wrote:
>>> This patch series contains:
>>> * cleanup of scheduled scan code.
>>> * fix handling schedules scan results for newer chips.
>>> * support for bcm43341 chipset with different chip id.
>>> * support rev6 of PCIe device interface.
>>>
>>> The series is intended for 4.10 and applies to the master branch
>>> of the wireless-drivers-next repository.
>>
>> Tested with BCM43602 on SR400ac router, it still initializes fine, I
>> can create multiple AP interfaces and use them.
>
> Thanks, Rafa=C5=82
>
> Extra testing for the PCIe rev6 support is always appreciated. Although
> I am not sure what rev your 43602 device has. At least we know it is not
> broken ;-)

I guess it's not rev6, my testing was just against possible regressions :)

--=20
Rafa=C5=82
