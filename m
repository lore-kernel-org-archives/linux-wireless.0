Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:50550 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751317AbdGQUNs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 16:13:48 -0400
Subject: Re: BUG: brcmfmac: add firmware feature detection for gscan feature
 breaks 43430a1
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
References: <25c47ffe-af3e-fb85-ed5b-ff1987cfd93f@mnementh.co.uk>
 <e6635794-7c35-1a46-2d5b-68824c7b0657@mnementh.co.uk>
 <ff344ee3-3feb-6886-8007-d8ed00386424@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <c322c7c6-823b-0d36-8968-101d143b3220@mnementh.co.uk> (sfid-20170717_221352_070366_68864EF3)
Date: Mon, 17 Jul 2017 21:13:45 +0100
MIME-Version: 1.0
In-Reply-To: <ff344ee3-3feb-6886-8007-d8ed00386424@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17/07/17 20:53, Arend van Spriel wrote:
>> 2) The firmware is failing when asked to handle the new requiests, and
>>    is going to la-la land.
> taken a wrong turn straight into la-la land.

Doh!

>> I have version wl0: Aug 29 2016 20:48:16 version 7.45.41.26 (r640327)
>> FWID 01-4527cfab
> Not so much newer firmware, but I used a different chip when
> implementing the multi-scheduled scan patches. I tried some other
> devices, but not the bcm4343{0,8}. Now as far as I can see over here the
> brcmfmac43430-sdio.bin is not built with gscan support so it should just
> return firmware errorcode, ie. -23. So it would be interesting to see
> what firmware has to say. Can you load the driver with
> ignore_probe_fail=1 and dump the forensics file in debugfs.

I don't appear to get anything useful in debugfs. Where should I be looking?

-Ian
