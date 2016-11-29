Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:36083 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754265AbcK2J6S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 04:58:18 -0500
Received: by mail-qt0-f181.google.com with SMTP id w33so149575944qtc.3
        for <linux-wireless@vger.kernel.org>; Tue, 29 Nov 2016 01:58:17 -0800 (PST)
Subject: Re: [PATCH 00/12] brcmfmac: scheduled scan cleanup and chip support
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <1479896731-5091-1-git-send-email-arend.vanspriel@broadcom.com>
 <CACna6rxszuTY3g=brCkWmwX7mT0-ptjpQMG+YTrPzfoc=dJvcA@mail.gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <a763eacb-edd9-e551-dad7-456fac580f14@broadcom.com> (sfid-20161129_105823_953885_F702D1F2)
Date: Tue, 29 Nov 2016 10:58:13 +0100
MIME-Version: 1.0
In-Reply-To: <CACna6rxszuTY3g=brCkWmwX7mT0-ptjpQMG+YTrPzfoc=dJvcA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 29-11-2016 8:37, Rafał Miłecki wrote:
> On 23 November 2016 at 11:25, Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> This patch series contains:
>> * cleanup of scheduled scan code.
>> * fix handling schedules scan results for newer chips.
>> * support for bcm43341 chipset with different chip id.
>> * support rev6 of PCIe device interface.
>>
>> The series is intended for 4.10 and applies to the master branch
>> of the wireless-drivers-next repository.
> 
> Tested with BCM43602 on SR400ac router, it still initializes fine, I
> can create multiple AP interfaces and use them.

Thanks, Rafał

Extra testing for the PCIe rev6 support is always appreciated. Although
I am not sure what rev your 43602 device has. At least we know it is not
broken ;-)

Regards,
Arend
