Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n1.bullet.mail.re3.yahoo.com ([68.142.237.108]:37275 "HELO
	n1.bullet.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751811AbYF1Kng (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 06:43:36 -0400
Message-ID: <486615D4.1020506@yahoo.it> (sfid-20080628_124340_563989_349071E7)
Date: Sat, 28 Jun 2008 12:43:32 +0200
From: Filippo Zangheri <filippo.zangheri@yahoo.it>
MIME-Version: 1.0
To: George Fong <george@lateralplains.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Problem making compat-wireless-2.6
References: <200806281953.16371.george@lateralplains.com>
In-Reply-To: <200806281953.16371.george@lateralplains.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 28/06/2008 11:53, George Fong wrote:
> Hi guys
>=20
> Not sure if this is a bug but I have not been able to make the compat=
 wireless=20
> drivers.
>=20
> I am running off Fedora 9 (x86_64) with kernel 2.6.25.6-55.fc9.x86_64=
=2E I am=20
> interested in the iwl4965 driver.

One simple solution would be to disable the building of unneeded
drivers by tuning your config.mk.

I suggest you to enable only the driver that you need.

Long answer, I don't know. Maybe some fix is needed to regain
compatibility. But, again, in your situation you can (and should for
efficienty's sake) forget about all the drivers that you don't care of.


> Everything goes OK until we hit the compilation of part of the b43 dr=
iver.=20
> This is what I get:
>=20
> /home/george/Download/compat-wireless-2008-06-28/drivers/net/wireless=
/b43/rfkill.c:=20
> In function =E2=80=98b43_rfkill_soft_toggle=E2=80=99:
> /home/george/Download/compat-wireless-2008-06-28/drivers/net/wireless=
/b43/rfkill.c:91:=20
> error: =E2=80=98RFKILL_STATE_UNBLOCKED=E2=80=99 undeclared (first use=
 in this function)
> /home/george/Download/compat-wireless-2008-06-28/drivers/net/wireless=
/b43/rfkill.c:91:=20
> error: (Each undeclared identifier is reported only once
> /home/george/Download/compat-wireless-2008-06-28/drivers/net/wireless=
/b43/rfkill.c:91:=20
> error: for each function it appears in.)
> /home/george/Download/compat-wireless-2008-06-28/drivers/net/wireless=
/b43/rfkill.c:101:=20
> error: =E2=80=98RFKILL_STATE_SOFT_BLOCKED=E2=80=99 undeclared (first =
use in this function)
> make[4]: ***=20
> [/home/george/Download/compat-wireless-2008-06-28/drivers/net/wireles=
s/b43/rfkill.o]=20
> Error 1
> make[3]: ***=20
> [/home/george/Download/compat-wireless-2008-06-28/drivers/net/wireles=
s/b43]=20
> Error 2
> make[2]: ***=20
> [/home/george/Download/compat-wireless-2008-06-28/drivers/net/wireles=
s] Error=20
> 2
> make[1]: *** [_module_/home/george/Download/compat-wireless-2008-06-2=
8] Error=20
> 2
> make[1]: Leaving directory `/usr/src/kernels/2.6.25.6-55.fc9.x86_64'
> make: *** [modules] Error 2
>=20
> It is entirely likely that I am doing something wrong but I don't kno=
w what.
>=20
> Hope this is all OK to report.
>=20
> Cheers
> G,
>=20
>=20

Best regards.

- --
=46ilippo Zangheri

GPG key ID: 0x6C1F2F2F
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIZhXUjzxMG2wfLy8RArPXAKCE4whKT29GICQKZh92oXPGv3CVcACfZNPi
tdbmbFS9HLOuyYzo5jdvg2M=3D
=3De3gp
-----END PGP SIGNATURE-----

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
