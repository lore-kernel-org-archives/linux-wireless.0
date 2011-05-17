Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34503 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab1EQBNV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 21:13:21 -0400
Received: by bwz15 with SMTP id 15so98683bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 May 2011 18:13:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=k_HQ2jh5dAeHs5PzWNmUtyhViNQ@mail.gmail.com>
References: <BANLkTimDudEKPEjTrWxm1wNA00Cmyot+sA@mail.gmail.com>
	<BANLkTi=cx1CJkuBgvKkd9tm1u2hu7WGYYA@mail.gmail.com>
	<BANLkTika=8VetqGXMX7XbsVRM9dBe7AUKA@mail.gmail.com>
	<BANLkTi=k_HQ2jh5dAeHs5PzWNmUtyhViNQ@mail.gmail.com>
Date: Mon, 16 May 2011 21:13:20 -0400
Message-ID: <BANLkTikPBuY4Dt=2XSBrR4s5Au-LaWhNiA@mail.gmail.com> (sfid-20110517_031330_562778_79EED7D4)
Subject: Re: what dictates the firmware directory of compat-wireless firmware?
From: George Nychis <gnychis@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> If android hacked udev into the init deamon then you will have to
> modify the init daemon too but I doubt that they would have kept udev
> rules statically in the init daemon, so try to find the udev rules.
>

I haven't been able to find any other udev rules on the Android
filesystem.  I have done a ton of digging for any udev information on
Android, without any luck.  I have asked on the Android mailing list,
we'll see how that goes.

In the mean time, the compat_firmware.sh script is pretty straight
forward.  My process on Android is continually monitoring the USB
devices connected, I could perform the same actions that
compat_firmware.sh does to dump the firmware into "/data"

Thanks for the udev related pointers in compat-wireless!
