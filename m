Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:47776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbXKTJ6x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 04:58:53 -0500
From: Andreas Schwab <schwab@suse.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	mb@bu3sch.de
Subject: Re: [PATCH v3] remove bcm43xx
References: <20071119202121.6ad3fa70@morte> <200711192300.12183.rjw@sisk.pl>
	<20071119231935.535674ba@morte> <jehcjheubn.fsf@sykes.suse.de>
	<20071120001329.3524494a@morte> <jed4u5esbo.fsf@sykes.suse.de>
	<20071120011549.6b04bb4d@morte>
Date: Tue, 20 Nov 2007 10:58:49 +0100
In-Reply-To: <20071120011549.6b04bb4d@morte> (Stefano Brivio's message of
	"Tue\, 20 Nov 2007 01\:15\:49 +0100")
Message-ID: <jeir3xdyqu.fsf@sykes.suse.de> (sfid-20071120_095858_834758_CB0BBB43)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefano Brivio <stefano.brivio@polimi.it> writes:

> --- drivers/net/wireless/b43/main.c.orig        2007-11-20 01:12:12.1=
86524483 +0100
> +++ drivers/net/wireless/b43/main.c     2007-11-20 01:12:34.922702865=
 +0100
> @@ -947,7 +947,7 @@
>
>         while (1) {
>                 v0 =3D b43_read32(dev, B43_MMIO_XMITSTAT_0);
> -               if (!(v0 & 0x00000001))
> +               if (!v0)
>                         break;
>                 v1 =3D b43_read32(dev, B43_MMIO_XMITSTAT_1);
>
> (probably it's not the solution, I just want to see what happens then=
).

That didn't change anything.

> BTW, what firmware are you using?

It's 410.2160 from wl_ap.o.

Andreas.

--=20
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstra=DFe 5, 90409 N=FCrnberg, Germany
PGP key fingerprint =3D 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4=
ED5
"And now for something completely different."
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
