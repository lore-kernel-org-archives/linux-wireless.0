Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from liberdade2.minaslivre.org ([74.50.53.203]:40895 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757785Ab0J2Ny5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Oct 2010 09:54:57 -0400
Date: Fri, 29 Oct 2010 11:54:50 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: seno <senada@t-online.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187b: do not do per packet TX AGC
Message-ID: <20101029135449.GB3768@barata.holoscopio.com>
References: <1282974868-22237-1-git-send-email-cascardo@holoscopio.com>
 <4C798080.8010002@lwfinger.net>
 <20100830141218.GB30864@tuxdriver.com>
 <4C7BC4D9.1010108@lwfinger.net>
 <20100830152841.GB2950@barata.holoscopio.com>
 <loom.20101026T200014-691@post.gmane.org>
 <4CC71CFF.8050004@lwfinger.net>
 <20101026185341.GA4608@barata.holoscopio.com>
 <20101028191305.2960c83b@gotham.conectiva>
 <loom.20101029T010426-834@post.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
In-Reply-To: <loom.20101029T010426-834@post.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 28, 2010 at 11:21:47PM +0000, seno wrote:
> Herton Ronaldo Krzesinski <herton@...> writes:
>=20
> > The excessive retries etc. should be another issue. The patch from Thad=
eu
> > really improves the driver.
>=20
> Well, I tried once more today, maybe I'm doing something wrong?
>=20
> - I run "./scripts/driver-select rtl818x" in compat-wireless-2010-10-28
> - then "patch -p1 rtl8187_dev.c rtl8187b-do-not-do-per-packet-TX-AGC.patc=
h"
> - then "make"
> - then "sudo make install"
> - then reboot
>=20
> "dmesg |grep compat" gives "Compat-wireless backport release: compat-
> wireless-2010-10-22-5-g69fdc09" so the new module is used.
>=20
> On speedtest.net, max speed is ~ 1mbit (on 10 mbit cable internet @10 met=
ers=20
> distance)
> The router reports an improved "Signal Quality", but iwconfig now shows:
>=20
> "Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0"
> "Tx excessive retries:2589  Invalid misc:17686   Missed beacon:0"
>=20
> Herton: If I make something wrong, can you please post your rtl8187.ko.gz=
=20
> (Mandriva 2010.1 / 2.6.33.7-desktop-2mnb x86_64)?
>=20
> Thank you.

Hello, seno.

Perhaps, the problem is related to using compat-wireless. Have you tried
using the module without the patch, using this same compat-wireless
version in the same linux version you are using?

Regards,
Cascardo.

--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJMytIpAAoJEEWxSg7udFZI2mcP/RU8kJOzKt18vvsBGfvcITFT
l5fdiApowymgzXUaRrlh4n19Jf8koKxNqwrR9fY2ckvm/t2WFJIkDwBAv7PfRTiO
6K+3L0JccTVjhLR/05cyaYdnGPlMaBQAJiv4L53EqHcgkR4rUgasjrDKoi7N00bo
BmQuIZBwTjT3MwKpFKxCLAA7mtIkuXsZkXzir9FKEc/Jkib1qJDJ4cN7s7Uhz/bO
Wu/zifT90BDczOhZwRA/uJfizTtmyeMnymqoWxt6f7l3HUPE25nBF+4CJtcSLrJc
6cjXJKgisJc4fcqVqixEja91/U3mrD21qPnw+8ywZZEzvO5c99BJ/cD29yjku4BQ
emhj9GZMtDTtnNewd9WYEgxZeT/TB+KDJZgKEJwDAi3R6e1/tXS3Zoiu3p7wy8ph
IFEM4iVRLGazX5VH7dGI4t2sSmPNzmRI0uVs2QJ55sc+949MId3zz/fVnkkXSIvm
4Xy/R7bDNoVNR/7WxYz/D/cdtVNoPF9m718ef3lRVk7RKeKlZaxAdN2S97g4TjVm
dmsth0iijrZAXIFyryHrWqXTHpTp+/DLegdGfvlm/CaSlhm+4yURBRSqyDuL5Skd
hPpXBDVngnLRPifMC+2f9D7H9vKjQF65fNzJcM34ItWfVbl8Do7hsAqD6xZnay2c
6EaxFZj7Bkd588z50QaT
=1+1x
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--
