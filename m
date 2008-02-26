Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:16510 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759322AbYBZGGs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 01:06:48 -0500
From: bruno randolf <bruno@thinktube.com>
To: cs010101@gmail.com
Subject: Re: ath5k : test
Date: Tue, 26 Feb 2008 15:06:32 +0900
Cc: linux-wireless@vger.kernel.org
References: <006501c87837$a7ef9590$3b0aa8c0@39fb6b6b6f434b3>
In-Reply-To: <006501c87837$a7ef9590$3b0aa8c0@39fb6b6b6f434b3>
MIME-Version: 1.0
Content-Type: text/plain; charset=euc-kr
Message-Id: <200802261506.32712.bruno@thinktube.com> (sfid-20080226_060712_892267_2FFD316D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hello =B1=E8=BF=B5=C8=AF!

thanks for the report, however it's very important to tell us which har=
dware=20
you are using. see the output of dmesg after ath5k is loaded and please=
=20
include that in the next report.

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
> so, I made 'mod_timer' comment in base.c (calibration section) and th=
en
> performance was increased.
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
> HTVC 3106 KAIST, 373-1 Guseong-dong, Yuseong-gu,
> Daejon,  Republic of Korea
> 305-701
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
