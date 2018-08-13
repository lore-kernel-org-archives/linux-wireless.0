Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36965 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728540AbeHMVMk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 17:12:40 -0400
Received: by mail-wr1-f67.google.com with SMTP id u12-v6so15097262wrr.4
        for <linux-wireless@vger.kernel.org>; Mon, 13 Aug 2018 11:29:17 -0700 (PDT)
Subject: Re: [PATCH] ath10k: retrieve MAC address from firmware if provided
To: Brian Norris <briannorris@chromium.org>
References: <20180810233948.144792-1-briannorris@chromium.org>
 <5B6F2A47.7070502@broadcom.com>
 <CA+ASDXOeybJAsWJtVBdLdQ=6xThJja5MaEoa3dERKZ-shkbDkg@mail.gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, govinds@codeaurora.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B71CDFB.60408@broadcom.com> (sfid-20180813_203030_235574_24B660E6)
Date: Mon, 13 Aug 2018 20:29:15 +0200
MIME-Version: 1.0
In-Reply-To: <CA+ASDXOeybJAsWJtVBdLdQ=6xThJja5MaEoa3dERKZ-shkbDkg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/13/2018 7:14 PM, Brian Norris wrote:
> On Sat, Aug 11, 2018 at 11:26 AM Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>>
>> On 8/11/2018 1:39 AM, Brian Norris wrote:
>>> Devices may provide their own MAC address via system firmware (e.g.,
>>
>> You got me confused by using just "firmware" in the subject.
>
> Yeah...I started by writing this patch with device tree specifically
> (of_get_mac_address()), and then later found that there were generic
> "device" helpers for this, which can assist with other sorts of
> firmware nodes. It was easier to put a name on a device tree patch
> than on a "device" patch. I suppose "system firmware" might be a
> better description?
>
>>> device tree), especially in the case where the device doesn't have a
>>> useful EEPROM on which to store its MAC address (e.g., for integrated
>>> Wifi).
>>>
>>> Use the generic device helper to retrieve the MAC address, and (if
>>> present) honor it above the MAC address advertised by the card.
>>
>> But this put me back on track ;-)
>
> Let me know if you have a better way to clarify. I can resend with a
> slightly modified subject (s/firmware/system firmware/), or let Kalle
> do it, if that's the only thing to change.

"system firmware" substitution works for me.

Regards,
Arend
