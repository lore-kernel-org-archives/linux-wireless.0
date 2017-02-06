Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:35192 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751250AbdBFGBT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 01:01:19 -0500
Received: by mail-ua0-f195.google.com with SMTP id 96so6350776uaq.2
        for <linux-wireless@vger.kernel.org>; Sun, 05 Feb 2017 22:01:18 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <ee13dae1-d01f-baff-a4d3-fe3e77fa85ec@leopoldosoria.com>
References: <CA+icZUXtJG18ejLynO1FB0BS5Guqr35-Bn0_Obht-VyGNO4tAg@mail.gmail.com>
 <6df84be9db053beae03eb31ece0ab2d7@mail.leopoldosoria.com> <CA+icZUVZ5mz4NmvrQit3Mz3GEbobR265Yd8YjVKF90=MBNQkAQ@mail.gmail.com>
 <db60d707-1cfe-f9b1-8d63-87e0121101e4@leopoldosoria.com> <ee13dae1-d01f-baff-a4d3-fe3e77fa85ec@leopoldosoria.com>
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Mon, 6 Feb 2017 07:01:17 +0100
Message-ID: <CA+icZUV-J0+jY8U=5_UwDf1Z7Qgnqswn+gAPhWm8YYkhqWLJjw@mail.gmail.com> (sfid-20170206_070206_079995_8D0DCD0F)
Subject: Re: Installing driver for Ubuntu 16.04 Intel(R) Wireless WiFi Link 4965AGN
To: Leopoldo <info@leopoldosoria.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 5, 2017 at 6:31 PM, Leopoldo <info@leopoldosoria.com> wrote:
> Dear Sedat,
>
> Did you have the chance to have a look to this?
>

No.
If it was not clear said: I did not promise to look at it, I just said
sent the logs and people here can look at it.

- Sedat -

> Kind regards.
>
> Leopoldo
>
>
> El 16/01/17 a las 21:33, Leopoldo escribi=C3=B3:
>
> Dear Sedat,
>
> Please, find attached the requested 2 files.
>
> Thanking you invaluable collaboration.
>
> Leopoldo
>
>
> El 02/01/17 a las 20:39, Sedat Dilek escribi=C3=B3:
>
> On Mon, Jan 2, 2017 at 7:11 PM,  <info@leopoldosoria.com> wrote:
>
> Dear Madam Sedat,
>
> Hehe, my family name is indeed a female first name - Sedat is male.
>
> Thank you for your answer.
>
> I already consulted Ubuntu Community but it is not so nice for a beginner
> like me. I tried several recomedations from them, but no way.  So, I
> thought, it is better to ask to the source.
>
> Yes, I have the firmware you mention, but wifi doesn't work. The icon app=
ear
> in the top bar but it doesn't seem to be conected. It doesn't seach
> conections even when wifi is activated. The ligh of wifi simbol in the
> laptop lights some times but others it doesn't.
>
> It's difficult to answer without knowing anything about your hardware,
> your WLAN infrastructure and your WLAN setup on Ubuntu/xenial.
>
> It might be helpful if you attach your linux-config and dmesg output.
>
> $ cp -v /boot/config-$(uname -r) /tmp
> $ dmesg > /tmp/dmesg.txt
>
> Attach those two files from /tmp directory and people can look at this.
>
> - Sedat -
>
> Any help is welcome and I won't forget ladies next time, sorry.
>
> Thank you for your help and have a happy new year 2017 also.
>
> Regards,
> Leopoldo
>
>
>
>
> El 02-01-2017 15:06, Sedat Dilek escribi=C3=B3:
>
> On Mon, Jan 2, 2017 at 2:11 PM,  <info@leopoldosoria.com> wrote:
>
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
> [ What about the Ladies, Sir :-)? ]
>
> Happy new 2017!
>
> You need the linux-firmware [1] package.
> Normally, Ubuntu/xenial should ship it.
>
> Check if you have...
>
> /lib/firmware/iwlwifi-4965-2.ucode
>
> ...file.
>
> Not sure why you are asking or what is not working.
> AFAICS, Ubuntu should have some nice wikis explaining a WLAN setup.
> A good strategy will always be to consult your distro's help before askin=
g
> here.
>
> [3] as a gift.
>
> Regards,
> - Sedat -
>
> [1] http://packages.ubuntu.com/xenial/linux-firmware
> [2] http://packages.ubuntu.com/xenial/all/linux-firmware/filelist
> [3] http://www.catb.org/~esr/faqs/smart-questions.html
>
>
>
