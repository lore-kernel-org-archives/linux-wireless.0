Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:53166 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751241AbdKIDLE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Nov 2017 22:11:04 -0500
Received: by mail-wm0-f45.google.com with SMTP id t139so14723664wmt.1
        for <linux-wireless@vger.kernel.org>; Wed, 08 Nov 2017 19:11:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB4CAwc0G0j1zb+Z4z6iCJ2hzMznUsSVxyF8G3dbZn9pxzffng@mail.gmail.com>
References: <CAB4CAwdO0dKAinnPk+ihJyDgOJ1z=2D=+pLMrObJYH+QiaDRqA@mail.gmail.com>
 <1509434718.4492.195.camel@coelho.fi> <CAB4CAwc43h5g+zLYd3hv=STELNGH+NEeQOMAXd-Gm0xj+TNuyA@mail.gmail.com>
 <1509952948.4492.360.camel@coelho.fi> <CAB4CAwc0G0j1zb+Z4z6iCJ2hzMznUsSVxyF8G3dbZn9pxzffng@mail.gmail.com>
From: Chris Chiu <chiu@endlessm.com>
Date: Thu, 9 Nov 2017 11:11:02 +0800
Message-ID: <CAB4CAwcwVEyFX=7KJcAT9eXQoof_M+U+tB+FRQCnoP5WgK-MrQ@mail.gmail.com> (sfid-20171109_041111_636418_D3B2D6C8)
Subject: Re: Need support for Intel new wifi module 9462NGW
To: Luca Coelho <luca@coelho.fi>
Cc: johannes.berg@intel.com, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luca,
    Any suggestion for the "Failed to start INIT ucode: -110" issue
for the firmware?

Chris

On Tue, Nov 7, 2017 at 12:26 PM, Chris Chiu <chiu@endlessm.com> wrote:
> Hi Luca,
>     I just tried the firmware but seems still something wrong. dmesg
> shows me the following
>
> [   17.786041] Intel(R) Wireless WiFi driver for Linux
> [   17.786042] Copyright(c) 2003- 2015 Intel Corporation
> [   18.120052] iwlwifi 0000:00:0c.0: loaded firmware version
> 33.610294.0 op_mode iwlmvm
> [   20.995731] iwlwifi 0000:00:0c.0: Detected Intel(R) Dual Band
> Wireless AC 9460, REV=0x318
> [   22.012109] iwlwifi 0000:00:0c.0: SecBoot CPU1 Status: 0x3, CPU2
> Status: 0x2339
> [   22.012115] iwlwifi 0000:00:0c.0: Failed to start INIT ucode: -110
> [   22.024100] iwlwifi 0000:00:0c.0: Failed to run INIT ucode: -110
>
> Any more information you need from me?
>
> Chris
>
> On Mon, Nov 6, 2017 at 3:22 PM, Luca Coelho <luca@coelho.fi> wrote:
>> On Mon, 2017-11-06 at 11:22 +0800, Chris Chiu wrote:
>>> Hi Luca,
>>
>> Hi Chris,
>>
>>
>>>     Any update for the firmware approval?
>>
>> Yes, I published it last Thursday.  Sorry, I was in such a hurry that I
>>  forgot to tell you about it.
>>
>> You can find it here:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git/plain/iwlwifi-9260-th-b0-jf-b0-33.ucode?id=f132386b542b52ade0416ecb6cb7aef426f5d175
>>
>> Let me know how it goes.
>>
>> --
>> Cheers,
>> Luca.
