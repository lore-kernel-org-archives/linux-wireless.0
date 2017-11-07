Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:43724 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751035AbdKGE0y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 23:26:54 -0500
Received: by mail-wm0-f46.google.com with SMTP id r68so11490760wmr.0
        for <linux-wireless@vger.kernel.org>; Mon, 06 Nov 2017 20:26:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1509952948.4492.360.camel@coelho.fi>
References: <CAB4CAwdO0dKAinnPk+ihJyDgOJ1z=2D=+pLMrObJYH+QiaDRqA@mail.gmail.com>
 <1509434718.4492.195.camel@coelho.fi> <CAB4CAwc43h5g+zLYd3hv=STELNGH+NEeQOMAXd-Gm0xj+TNuyA@mail.gmail.com>
 <1509952948.4492.360.camel@coelho.fi>
From: Chris Chiu <chiu@endlessm.com>
Date: Tue, 7 Nov 2017 12:26:52 +0800
Message-ID: <CAB4CAwc0G0j1zb+Z4z6iCJ2hzMznUsSVxyF8G3dbZn9pxzffng@mail.gmail.com> (sfid-20171107_052659_568448_889DE799)
Subject: Re: Need support for Intel new wifi module 9462NGW
To: Luca Coelho <luca@coelho.fi>
Cc: johannes.berg@intel.com, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luca,
    I just tried the firmware but seems still something wrong. dmesg
shows me the following

[   17.786041] Intel(R) Wireless WiFi driver for Linux
[   17.786042] Copyright(c) 2003- 2015 Intel Corporation
[   18.120052] iwlwifi 0000:00:0c.0: loaded firmware version
33.610294.0 op_mode iwlmvm
[   20.995731] iwlwifi 0000:00:0c.0: Detected Intel(R) Dual Band
Wireless AC 9460, REV=0x318
[   22.012109] iwlwifi 0000:00:0c.0: SecBoot CPU1 Status: 0x3, CPU2
Status: 0x2339
[   22.012115] iwlwifi 0000:00:0c.0: Failed to start INIT ucode: -110
[   22.024100] iwlwifi 0000:00:0c.0: Failed to run INIT ucode: -110

Any more information you need from me?

Chris

On Mon, Nov 6, 2017 at 3:22 PM, Luca Coelho <luca@coelho.fi> wrote:
> On Mon, 2017-11-06 at 11:22 +0800, Chris Chiu wrote:
>> Hi Luca,
>
> Hi Chris,
>
>
>>     Any update for the firmware approval?
>
> Yes, I published it last Thursday.  Sorry, I was in such a hurry that I
>  forgot to tell you about it.
>
> You can find it here:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git/plain/iwlwifi-9260-th-b0-jf-b0-33.ucode?id=f132386b542b52ade0416ecb6cb7aef426f5d175
>
> Let me know how it goes.
>
> --
> Cheers,
> Luca.
