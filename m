Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42580 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbXKSWgq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 17:36:46 -0500
From: Andreas Schwab <schwab@suse.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	mb@bu3sch.de
Subject: Re: [PATCH v3] remove bcm43xx
References: <20071119202121.6ad3fa70@morte> <200711192300.12183.rjw@sisk.pl>
	<20071119231935.535674ba@morte>
Date: Mon, 19 Nov 2007 23:36:44 +0100
In-Reply-To: <20071119231935.535674ba@morte> (Stefano Brivio's message of
	"Mon\, 19 Nov 2007 23\:19\:35 +0100")
Message-ID: <jehcjheubn.fsf@sykes.suse.de> (sfid-20071119_223649_028329_2561B167)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefano Brivio <stefano.brivio@polimi.it> writes:

> On Mon, 19 Nov 2007 23:00:11 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>
>> Well, are you 100% sure that everyone interested knows that this dri=
vers
>> is going out in 2.6.25 and no one will object?
>
> The maintainers know. Having both drivers in 2.6.24 should help find =
out if
> there's anything which should be ironed out with b43/b43legacy, but r=
ight
> now they are already working a lot better than bcm43xx, and they are =
more
> stable. So I couldn't find a reason why we shouldn't remove bcm43xx i=
n
> 2.6.25.

b43 still does not work at all on ppc.

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
