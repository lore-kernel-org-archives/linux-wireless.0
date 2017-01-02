Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:35972 "EHLO
        mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750815AbdABOGF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 09:06:05 -0500
Received: by mail-ua0-f194.google.com with SMTP id v2so14883850uac.3
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jan 2017 06:06:05 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Mon, 2 Jan 2017 15:06:04 +0100
Message-ID: <CA+icZUXtJG18ejLynO1FB0BS5Guqr35-Bn0_Obht-VyGNO4tAg@mail.gmail.com> (sfid-20170102_150608_870732_4ACECB95)
Subject: Re: Installing driver for Ubuntu 16.04 Intel(R) Wireless WiFi Link 4965AGN
To: info@leopoldosoria.com
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 2, 2017 at 2:11 PM,  <info@leopoldosoria.com> wrote:
> Dear Sirs,
> Which of the below drivers should I install for my Lenovo 3000 V200?
> I am runing Ubuntu 16.04
>
> Intel=C2=AE Wireless WiFi Link 4965AGN
> 2.6.24+ iwlwifi-4965-ucode-4.44.14.tgz
> 2.6.24+ iwlwifi-4965-ucode-4.44.15.tgz
> 2.6.24+ iwlwifi-4965-ucode-4.44.17.tgz
> 2.6.24+ iwlwifi-4965-ucode-4.44.1.18.tgz
> 2.6.24+ iwlwifi-4965-ucode-4.44.1.20.tgz
> 2.6.24+ iwlwifi-4965-ucode-228.57.1.21.tgz
> 2.6.28+ (?)     iwlwifi-4965-ucode-228.57.2.21.tgz
> 2.6.28+ (?)     iwlwifi-4965-ucode-228.57.2.23.tgz
> 2.6.28+ (?)     iwlwifi-4965-ucode-228.61.2.24.tgz
>
> Ans how shoudl I proceed for intalling the right driver?
>
> Thank you
>

[ What about the Ladies, Sir :-)? ]

Happy new 2017!

You need the linux-firmware [1] package.
Normally, Ubuntu/xenial should ship it.

Check if you have...

/lib/firmware/iwlwifi-4965-2.ucode

...file.

Not sure why you are asking or what is not working.
AFAICS, Ubuntu should have some nice wikis explaining a WLAN setup.
A good strategy will always be to consult your distro's help before asking =
here.

[3] as a gift.

Regards,
- Sedat -

[1] http://packages.ubuntu.com/xenial/linux-firmware
[2] http://packages.ubuntu.com/xenial/all/linux-firmware/filelist
[3] http://www.catb.org/~esr/faqs/smart-questions.html
