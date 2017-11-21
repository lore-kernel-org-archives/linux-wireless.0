Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:43118 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751669AbdKUJaz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 04:30:55 -0500
Received: by mail-lf0-f68.google.com with SMTP id 73so13266284lfu.10
        for <linux-wireless@vger.kernel.org>; Tue, 21 Nov 2017 01:30:55 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1511175768.4011.261.camel@coelho.fi>
References: <1511175768.4011.261.camel@coelho.fi>
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Tue, 21 Nov 2017 10:30:53 +0100
Message-ID: <CA+icZUVqhmH3dyMXkHKsHus5qyfMqQfcOctvHRDf4x=6+ndfPw@mail.gmail.com> (sfid-20171121_103241_955353_B5D33D0B)
Subject: Re: pull-request: iwlwifi 2017-11-19
To: Luca Coelho <luca@coelho.fi>
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        linuxwifi <linuxwifi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 20, 2017 at 12:02 PM, Luca Coelho <luca@coelho.fi> wrote:
[..]
> ----------------------------------------------------------------
> iwlwifi: first set of fixes for 4.15
>
> * Support new FW API version of scan cmd (used in FW version 34);

While seeing this...
I have here a iwlwifi-8265 hardware and have seen a recently uploaded
FW-version 34 in iwlwifi-firmware Git.
Can you explain the dependence of iwlwifi firmware-version / Linux
kernel-release and especially probing?
Currently, I am using Linux v4.14 from Debian/experimental.

- Sedat -

P.S.: From my logs

[   10.630285] iwlwifi 0000:04:00.0: firmware: failed to load
iwlwifi-8265-34.ucode (-2)
[   10.630331] iwlwifi 0000:04:00.0: Direct firmware load for
iwlwifi-8265-34.ucode failed with error -2
[   10.630454] iwlwifi 0000:04:00.0: firmware: failed to load
iwlwifi-8265-33.ucode (-2)
[   10.630479] iwlwifi 0000:04:00.0: Direct firmware load for
iwlwifi-8265-33.ucode failed with error -2
[   10.630486] iwlwifi 0000:04:00.0: firmware: failed to load
iwlwifi-8265-32.ucode (-2)
[   10.630510] iwlwifi 0000:04:00.0: Direct firmware load for
iwlwifi-8265-32.ucode failed with error -2
[   10.636423] iwlwifi 0000:04:00.0: firmware: direct-loading firmware
iwlwifi-8265-31.ucode
[   10.637463] iwlwifi 0000:04:00.0: loaded firmware version
31.532993.0 op_mode iwlmvm
