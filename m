Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51550 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbZHUPLZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 11:11:25 -0400
Subject: Re: Plans for an online meeting regarding Radiotap
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Richard Farina <sidhayn@gmail.com>,
	Mike Kershaw <dragorn@kismetwireless.net>,
	Sam Leffler <sam@freebsd.org>,
	Rafael Laufer <rlaufer@cs.ucla.edu>,
	Damien Bergamini <damien.bergamini@free.fr>,
	Sepherosa Ziehau <sepherosa@gmail.com>,
	Thomas d'Otreppe <tdotreppe@aircrack-ng.org>,
	Dave Young <hidave.darkstar@gmail.com>,
	radiotap <radiotap@radiotap.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	freebsd-mobile <freebsd-mobile@freebsd.org>,
	misc-openbsd <misc@openbsd.org>, tech-openbsd <tech@openbsd.org>,
	netbsd-net <tech-net@netbsd.org>,
	wireshark-dev <wireshark-dev@wireshark.org>
In-Reply-To: <69e28c910908210804h6181aab1w4a864392239aa1ac@mail.gmail.com>
References: <4A8EAFA6.9010608@gmail.com>
	 <1250865255.4600.6.camel@johannes.local>
	 <69e28c910908210741wd3bc391x311523f5b55fd4f1@mail.gmail.com>
	 <1250865918.4600.9.camel@johannes.local>
	 <69e28c910908210804h6181aab1w4a864392239aa1ac@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ElfnJgk9tnc3Yp/l4bdE"
Date: Fri, 21 Aug 2009 17:11:19 +0200
Message-Id: <1250867479.4600.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ElfnJgk9tnc3Yp/l4bdE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-21 at 17:04 +0200, G=C3=A1bor Stefanik wrote:

> I've reworked RTS/CTS since then, just haven't got to sending a new
> proposal yet. The current plan is as follows:
>=20
> TX_FLAGS & 0x0002: Use CTS
> TX_FLAGS & 0x0004: Use RTS
> TX_FLAGS & 0x0020: Disable RTS/CTS usage

Seems a bit strange, wouldn't setting neither RTS nor CTS have the
effect? Seems like 0x20 should rather be "use automatic and ignore the
other bits". Anyway, not appropriate here, you should just bring a new
proposal.

> If I remember correctly, I made an implementation for the Linux kernel
> (a generator-side implementation) and one for Wireshark (a parser-side
> implementation). Or should I make two generator-side implementations
> according to the requirement (e.g. one for Linux, another for
> OpenBSD)?

No, that was ok, I just meant that therefore by definition it can't be a
problem of lack of implementations.

johannes

--=-ElfnJgk9tnc3Yp/l4bdE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKjrkUAAoJEODzc/N7+QmalQsP/iShDji6pLnoxRRQH9hIITK5
Su/qvKUnalSzN+Yo0nw6SS2ZWDAApWGgQv0ipIS/1yDFyunsb0DFVte3YEyKU6el
cal0ncZFOVon+dguVzpHljD3DKPEsg92o9UzH0sKa3PLDIvqWXRAvgKlyP3cwTqG
aJwIOI0YiZpaEbF/VyeEVkjk7lXyzLxs238sC/H9ysXU9DuKlELadRyOBuLB0lt9
mIbVXCZSxe04jLMg7Yn5B5NCsdLcE1PrM1NmljCZWDeJW4aVdsAl5JGf10ewLetb
ea35bEZcr6W15CU/zotk+d03Ryf/rghwduPyIawcqtQtHhyIfqWlkxU0ikYgYJIM
y1Mh+ZD4F6cetzEHkORdMMzuWMkplvDReiu+l6+0zoKGqAa/pH1A+McitEHl6qTi
vQYyGZodDbAf9zWujmDSVHXECvkjeSRDbdFJiwz2MG3rcQYJmcWRhOaAnvAuh2j3
LOAWvOVVEA5eU/rZYyjVqcidwFkcEGlXzOuj9t+NkEg9X+BpEKmBdj4fPP2rEQNZ
xjZ7xrXRL7mw+nn3a2oJLMuzN9IPReuUotoHsSmuHijVUVqpIkhvC8ZDuwVDZtKR
Kw+NuFt75ViEaOCKUb/qEoJExpGxY0dG2JctnuZeeyIFushslEmzw07QwKXCNXdv
EaNIs2pGTsW1AyF/Fwh9
=Im+o
-----END PGP SIGNATURE-----

--=-ElfnJgk9tnc3Yp/l4bdE--

