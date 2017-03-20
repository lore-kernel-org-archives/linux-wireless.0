Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:36832 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752569AbdCTRsY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 13:48:24 -0400
Received: by mail-oi0-f45.google.com with SMTP id r203so21801618oib.3
        for <linux-wireless@vger.kernel.org>; Mon, 20 Mar 2017 10:47:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <70ad78bc-2a94-3391-797b-d7f074ccd4fa@lwfinger.net>
References: <CADND2bqVLdSmmY=RG7m8r2maWyc7yGgvKUO4O4YGPLVnMx0pqg@mail.gmail.com>
 <34e317ae-a112-79bc-41ef-c18433e8cc49@lwfinger.net> <CADND2bprCVNThAWVp-De7W3uRvKNDxGrxEond2ANZ+=2akKB_Q@mail.gmail.com>
 <20064021-fcca-4092-e6ec-5ce7f964a0c1@lwfinger.net> <CADND2br8jjW1jmuW3e4Jg4CxVaHCDEs2M4PHNtUuh9uMaC4BCQ@mail.gmail.com>
 <70ad78bc-2a94-3391-797b-d7f074ccd4fa@lwfinger.net>
From: Fernanda Vejar <fvejar85@gmail.com>
Date: Mon, 20 Mar 2017 14:47:28 -0300
Message-ID: <CADND2bpeRx6OGc=ZZXmPnCzoW0-kigibSuzoD751C9QqROAQDw@mail.gmail.com> (sfid-20170320_184835_430969_B7378FF7)
Subject: Re: Wireless failed
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Larry,

ok thank you, I will consider your advice.

I run:  "cp iwlwifi-2030-6.ucode /lib/firmware". I checked it out and
it was right copied into the folder.

Fernanda


2017-03-20 14:33 GMT-03:00 Larry Finger <Larry.Finger@lwfinger.net>:
> On 03/20/2017 11:46 AM, Fernanda Vejar wrote:
>>
>> Hello Larry,
>>
>> thank you very much for your fast answer.
>>
>> Buy running "modinfo iwlwifi":
>> filename:
>>
>> /lib/modules/3.13.0-112-lowlatency/updates/drivers/net/wireless/iwlwifi/iwlwifi.ko
>> version:        iwlwifi-stack-public:release/LinuxCore5:3714:27076532
>> license:        GPL
>> author:         Copyright(c) 2003- 2014 Intel Corporation
>> <ilw@linux.intel.com>
>> version:        in-tree:d
>> description:    Intel(R) Wireless WiFi driver for Linux
>> firmware:       iwlwifi-7265-8.ucode
>> firmware:       iwlwifi-3160-8.ucode
>> firmware:       iwlwifi-7260-8.ucode
>> firmware:       iwlwifi-8000-8.ucode
>> srcversion:     6E29C5B96E10698E38DC01F
>> ....
>>
>> According to the reference
>> (https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi#firmware) I
>> need  the iwlwifi-2030-6.ucode. I tried to install it previously as a
>> first step, but It didn't work. I don't understand what I did wrong.
>
>
> On this list, please do not top post. When you put your information at the
> top, then the reader has to go all the way to the bottom, then back to the
> top. Having everything in chronological order is easier.
>
> The driver is in your kernel. All we need now is the firmware. Where did you
> put the file? It should have been in /lib/firmware.
>
> Larry
>
>
