Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40324 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759404AbZJPOrG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 10:47:06 -0400
Subject: Re: [PATCH] mac80211: fixed injection in monitor mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Gabriele Gristina <matrix.use.linux@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1255658961.23827.2.camel@el8pc>
References: <1255658961.23827.2.camel@el8pc>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+AFxNfykLo21GInDJlgA"
Date: Fri, 16 Oct 2009 23:46:22 +0900
Message-Id: <1255704382.4095.340.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+AFxNfykLo21GInDJlgA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-10-16 at 04:09 +0200, Gabriele Gristina wrote:
> I have a problem with mac80211 injection:
> if i setup interface in monitor mode with iwconfig and i try to send a
> custum 802.11 frame i see twice the packet in monitor interface.
> The first packet is right, the second is different only in the radiotap
> header: rtap len is fixed to 13 bytes...
> If i setup interface with airmon-ng the packet is sended once but the
> radiotap header is fixed to 13 bytes.

This is correct. The patch is wrong.

johannes

--=-+AFxNfykLo21GInDJlgA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK2Ic6AAoJEODzc/N7+QmaJrIP/1nYgW866jcAetu/P5SbOY/7
cO64SBF3857HIg5GVwFGGy2NHhCm8wJY39okhrqJN+vOi23PwrPDcJ+KEfjPjx7S
Ue7RzWNZ1n2zvsIZghxeA0kgUM0bQAm9p6j6N4hdNC/J0V7m9fSNN6GZP6xukS1U
PurnyLEsB1wqYMkQnIrstTjW4/vHvEDwuLcJnB6VomQCpQemZO3Pd4gpAISBVorR
yM1Wz2Wug5fJJEOFh0DAYa/f9O5OIWTb+hp/HKlhPoF3t+Ac9Cme7IosmCxk8uni
knT68RUrn86ThEw0ZN9NBxHdD7++UCrZmhKSeDDQGELgsHUWPr9xDetNywVCtGjI
3Kh13pQF6ftS8QFWxrk2wqXKOQaXKoWYgR2nzCwJNu1r11CKLMJ3NfyPreB3YSVV
IwMbfsNsLRveSqVmHnH0FG8m7xQjHkjR7y5Fd4ke1rfEMWAQsuXIuwnMLJ1vXimp
Wswg+cvWbHiA9cqd1B//79S4Pqwtq/Wzlt0sVaAXIcx7zq74FXeq8EKCMxXhYosa
fGLBLiYggQ9/E5b5HFByQR5sn6aryP8nsNXwMsx33LN2DJ373meG6qBGZ1NUT0yX
AX190YPSuGQSzHeEuNBgIAH9VKChv3Iat4GCC9LRMHFgG/N1gKsfFE+GHPJ7TPmX
fYO5CZT4S2RUd0/c9ofo
=CQLt
-----END PGP SIGNATURE-----

--=-+AFxNfykLo21GInDJlgA--

