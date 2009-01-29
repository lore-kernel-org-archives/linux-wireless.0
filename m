Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51791 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765758AbZA2AeH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 19:34:07 -0500
Subject: Re: [PATCH resend] crda: rename nl_handle to nl_sock for libnl-2.0
From: Johannes Berg <johannes@sipsolutions.net>
To: pat-lkml <pat-lkml@erley.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4980F67C.70207@erley.org>
References: <4980EDC8.4050204@erley.org>
	 (sfid-20090129_004437_360979_B9D4728F) <1233187526.16048.95.camel@johannes.local>
	 <4980F67C.70207@erley.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NnPiUlhhuRgchULtc9Am"
Date: Thu, 29 Jan 2009 01:32:44 +0100
Message-Id: <1233189164.16048.106.camel@johannes.local> (sfid-20090129_013413_249766_3C7CECFA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NnPiUlhhuRgchULtc9Am
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-28 at 19:21 -0500, pat-lkml wrote:
> Johannes Berg wrote:
> > On Wed, 2009-01-28 at 18:44 -0500, pat-lkml wrote:
> >> Upstream has renamed nl_handle to nl_sock.  Update crda to the new nam=
es
> >> and add #define for libnl-1.1.
> >=20
> > But libnl-2.0 comes with a define too:
> > #define nl_handle nl_sock
> >=20
> > you just need to include the right headers, no?
> >=20
> > johannes
>=20
> dunno.... but I can't find it:
>=20
> libnl $ egrep "#define nl_handle" * -r
> libnl $ git pull
> Already up-to-date.

Ah. Grr. Just recently removed.

johannes

--=-NnPiUlhhuRgchULtc9Am
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgPkqAAoJEKVg1VMiehFYHZYQAJBO47MaGjlE8d3RkXXWxoyK
p9+DhCq85ojedJNm8xTuOHL66LxWlGGNtpd1lZxsgbgx556Z8oUa641qzqvt5L+G
taF+4WXuY2SxKhrfEH9AdhSc2VTD1BCLKaA052GP1McUGcxHOF2O9L46JI/KeHmD
lZ3gDSacHNjmTEgsErNenKXcrq0J7UvE0IMHoD2YNLlb11slKgiO4ny38UnxDhpP
UoJsSme7w/JRiyhorUAcXKBVQivddyRP2bkCrm+nYfEsB2edDLn3JnyqvjBxCZwZ
M0kkdVYqQ7DfeqKhWEwfi7/ubcynrIW0hSO3SVzALggvgK0p6j1ggfjxIdZTe5DZ
B6cV1sT60IchK3jbUIggFg/lRw6MqAOwUCPLnz/PFKZHK41oKoK0WiQ9pc8H4OL5
dnwLoc+A7RXyNEl4CvPwxUXpG7Zaywn20aak7AVidxu+iqIMiTQWeh0r5BA+mL0q
E8za5TY9fg+HPxJPETZCc6LLa6MJ+a7rxmKnIE3qGCADzHIXMeHKs2UYtiXnqSgC
qQZl3LVuaBDayV+6DjxBx2CFz/7IfHI/LDtXn/c7BFRe/8KtFN2TCjPAxWVWRffi
RXAL2HHoh7qR+NzJApOL0DriInDXalfTD+Wh+TtYxGcuLB4m+Qf5/IZx2hKAF7OK
xwDICTRilslH+hQa+tjF
=b3JG
-----END PGP SIGNATURE-----

--=-NnPiUlhhuRgchULtc9Am--

