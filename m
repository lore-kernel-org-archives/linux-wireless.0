Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:54693 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524AbXKTOry (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 09:47:54 -0500
From: Andreas Schwab <schwab@suse.de>
To: Michael Buesch <mb@bu3sch.de>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH v3] remove bcm43xx
References: <20071119202121.6ad3fa70@morte> <200711201507.46998.mb@bu3sch.de>
	<je4pfhdn2c.fsf@sykes.suse.de> <200711201520.05718.mb@bu3sch.de>
Date: Tue, 20 Nov 2007 15:47:53 +0100
In-Reply-To: <200711201520.05718.mb@bu3sch.de> (Michael Buesch's message of
	"Tue\, 20 Nov 2007 15\:20\:05 +0100")
Message-ID: <jeve7xc6sm.fsf@sykes.suse.de> (sfid-20071120_144757_589335_08D4B2F9)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch <mb@bu3sch.de> writes:

> On Tuesday 20 November 2007 15:11:07 Andreas Schwab wrote:
>> Michael Buesch <mb@bu3sch.de> writes:
>>=20
>> > On Monday 19 November 2007 23:36:44 Andreas Schwab wrote:
>> >> b43 still does not work at all on ppc.
>> >
>> > This is absolutely _wrong_.
>>=20
>> Of course it is wrong, but apparently the only way to get attention =
to a
>> blocker bug.
>
> I didn't hear about your bug before.
>
> Are you using latest driver from wireless-2.6 and the officially
> supported firmware version from
> http://www.linuxwireless.org/en/users/Drivers/b43

I have now downgraded the firmware (I was foolishly assuming that all
firmware versions recognized by b43-fwcutter are equally supported), an=
d
the error does not occur any more.  Thanks for your help.

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
