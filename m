Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.227]:50668 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367AbYBZHV7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 02:21:59 -0500
Received: by wx-out-0506.google.com with SMTP id h31so1963917wxd.4
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 23:21:56 -0800 (PST)
Reply-To: <cs010101@gmail.com>
From: =?ks_c_5601-1987?B?sei/tciv?= <cs010101@gmail.com>
To: "'bruno randolf'" <bruno@thinktube.com>
Cc: <linux-wireless@vger.kernel.org>
References: <006501c87837$a7ef9590$3b0aa8c0@39fb6b6b6f434b3> <200802261506.32712.bruno@thinktube.com>
Subject: RE: ath5k : test
Date: Tue, 26 Feb 2008 16:21:50 +0900
Message-ID: <006901c87848$42f06b90$3b0aa8c0@39fb6b6b6f434b3> (sfid-20080226_072224_230624_C267536F)
MIME-Version: 1.0
Content-Type: text/plain; charset=ks_c_5601-1987
In-Reply-To: <200802261506.32712.bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 yes...^^ forgot it.

current environment :

vanilla kernel 2.6.23.16
compat wireless 2.6 driver (date : Dec, 2007)
chipset : AR5414
3com 3CRDAG675B

loading module, dmesg:
-----------------------------------------------------------------------=
-----
---------------------
ath5k_pci 0000:02:0b.0: registered as 'phy0'
ath5k phy0: Device only partially supported.
phy0: Selected rate control algorithm 'simple'
ath5k phy0: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)
net wlan2: device_rename: sysfs_create_symlink failed (-17)
udev: renamed network interface wlan0 to wlan2
ADDRCONF(NETDEV_UP): wlan2: link is not ready
-----------------------------------------------------------------------=
-----
--------------------

-----Original Message-----
=46rom: bruno randolf [mailto:bruno@thinktube.com]=20
Sent: Tuesday, February 26, 2008 3:07 PM
To: cs010101@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath5k : test

hello =B1=E8=BF=B5=C8=AF!

thanks for the report, however it's very important to tell us which
hardware you are using. see the output of dmesg after ath5k is loaded a=
nd
please include that in the next report.

bruno

On Tuesday 26 February 2008 14:22:58 =B1=E8=BF=B5=C8=AF wrote:
> date : 26, Feb (driver's also same)
>
> conclusion:
>
> setting 802.11a ad-hoc,
>
> 5Ghz channel is different.
>
> and iwconfig wlanX rate [more than 24Mbps] : disconnected!
>
> and when I testing, performance was terrible. so often stalled.
>
> so, I made 'mod_timer' comment in base.c (calibration section) and=20
> then performance was increased.
>
> BUT also when I set more than 24Mb, disconnected.
>
> but until now, only atheros driver supports 802.11a with ad-hoc. than=
ks.
> :-)
>
> hmm...
> soon or later, we'll test ralink chipset.
>
>
> --
> --
> Have a Wonderful Day~~!!
> =B1=E8=BF=B5=C8=AF (James-Youngwhan Kim)
> yhkim@corebell.co.kr
> cs010101@gmail.com
> +82-42-863-0340
> +82-10-6753-0987
> HTVC 3106 KAIST, 373-1 Guseong-dong, Yuseong-gu, Daejon,  Republic of=
=20
> Korea
> 305-701
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess"
> in the body of a message to majordomo@vger.kernel.org More majordomo=20
> info at  http://vger.kernel.org/majordomo-info.html


-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
