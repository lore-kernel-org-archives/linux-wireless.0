Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36140 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbZDKLf1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Apr 2009 07:35:27 -0400
Subject: Re: attempt to scan fails (device busy) if essid/ssid was changed
 recently
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1239396421.13792.6.camel@maxim-laptop> (sfid-20090410_224706_132954_59888001)
References: <1239062401.4705.23.camel@maxim-laptop>
	 (sfid-20090407_020013_939126_90578556)  <1239092296.22453.1.camel@johannes.local>
	 <1239108689.15015.3.camel@maxim-laptop>
	 (sfid-20090407_145137_740898_8D0C40FD)  <1239109001.22453.40.camel@johannes.local>
	 <1239109497.15015.12.camel@maxim-laptop>
	 (sfid-20090407_150534_375314_4DA28551)  <1239110010.22453.41.camel@johannes.local>
	 <1239110412.15015.23.camel@maxim-laptop>
	 (sfid-20090407_152021_060436_AEF9110F)  <1239110860.4084.0.camel@johannes.local>
	 <1239112310.15015.25.camel@maxim-laptop>
	 <1239135878.17958.11.camel@maxim-laptop>
	 (sfid-20090407_222443_633750_085B264D)  <1239136637.7475.57.camel@johannes.local>
	 <1239395434.13792.3.camel@maxim-laptop>
	 <1239396421.13792.6.camel@maxim-laptop>
	 (sfid-20090410_224706_132954_59888001)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-i/OrS4sgR0m5zIBD7jjr"
Date: Sat, 11 Apr 2009 13:35:24 +0200
Message-Id: <1239449724.17031.44.camel@johannes.local> (sfid-20090411_133529_945282_0ADE70A5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-i/OrS4sgR0m5zIBD7jjr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-04-10 at 23:47 +0300, Maxim Levitsky wrote:

> And I found out why device is always busy, when wpa supplicant tries to
> scan. It is the disassociation sequence.
>=20
> Does kernel notify, when disassociation have finished?
> Maybe it is still better not to fail scan request, but block?

Can you _please_ be more explicit? What _is_ with the association
sequence? I already _know_ that setting a random ESSID will block scans,
and no, I don't think blocking is a good idea, and no, there's nothing
to do about it.

johannes

--=-i/OrS4sgR0m5zIBD7jjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ4IB5AAoJEKVg1VMiehFYPGYP/2FRQmsQQk0UdVhXn5cleWCB
ozTILNluDqsb0fx1GI+UCEzsgzcsW0+ou73d8BDsGu3n7l1za8+61xNP9IGUVvOX
7IOhpN+mC8NJ0V73gTyKCcHF3OeqB3MbXAifNa2nM/+11IdHGb1WRGOj2QO1Izy0
VWqSMOLlrGdB58u+INQnCgvYwZF9biFM0qI1BJVPWrXOQ9TmuJ4HzldcwDJinw8L
SB/Cb1YPxf9wSk31rCxAicrzckTYq5wqLhBemp/urI/STVbI/MepO5QOXHaiCqS3
8OSz0GeX6BYkwb4DgxtUWuUJORmFPD+mHv/r4AnlqWntkFSiNFCbP8HE3wC25uF9
iX4uk2TQHf5vMzWzPtoq3Oz7Q7ZZ4EovHh1qcx3zQXlGqaHTeeFT/kjMFvik8SQw
UI8Q5CM30jmU3wEFu7tusiGemS6NiGfrrRmWhskI5qkQw/PbIMgYAEMZ9fpmrccl
r0eu8oIVC0MlyI9vhyRCTBJNhKAtANTuvdpRpLMXpf+XFrI9cJtXmBbWbmUEgTiH
ZsC0qbA9kegT92GkDf6qFF8MD06FNzuFU2mCjrzzJ1XeZJj1+yZeAEhjp4hhQ50+
UYq0yINYMy9Zb96KrtBYApYlUMMrJuEBgidpxfivQTMRV9/fc9+KS47fLd7nQ/Fd
pPb4krkO8PnZo6VPciDR
=sERF
-----END PGP SIGNATURE-----

--=-i/OrS4sgR0m5zIBD7jjr--

