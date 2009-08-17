Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42586 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbZHQKjf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 06:39:35 -0400
Subject: Re: [ANN] iw: v0.9.16
From: Johannes Berg <johannes@sipsolutions.net>
To: drago01 <drago01@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <f6ca9fed0908170336u50df5a48v80fa34549fc08e87@mail.gmail.com>
References: <E1McscB-0004xM-M5@sipsolutions.net>
	 <f6ca9fed0908170336u50df5a48v80fa34549fc08e87@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-YUwC4e1zzkxfj3XCOQdE"
Date: Mon, 17 Aug 2009 12:39:34 +0200
Message-Id: <1250505574.15103.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YUwC4e1zzkxfj3XCOQdE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-08-17 at 12:36 +0200, drago01 wrote:
> On Mon, Aug 17, 2009 at 5:10 AM, <wireless@sipsolutions.net> wrote:
> >
> > A new release of iw (v0.9.16) is available at:
> >
> > http://wireless.kernel.org/download/iw/iw-0.9.16.tar.bz2
> >
> > SHA1 sum: e224b6698802498569854b475ae532d41ddbd719
> >
> > Here is the short log of the changes included in this
> > release:
>=20
> It is indeed very short ;)

Yeah, must be a bug in the script...

The real shortlog would have been

0.9.16
Revert "magically set interface up for connect/join"
mark a key default if none is marked manually
add iw commands for setting fragmentation and rts threshold
iw: fix typos in MCS set parsing code
print out wmm aifsn
some wmm parameter improvements
fix typo
fix bug parsing ACI
show WMM parameters
iw: add beacon hint event parsing
add warning about screenscraping
add missing newline
add link command
magically set interface up for connect/join


johannes

--=-YUwC4e1zzkxfj3XCOQdE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKiTNjAAoJEODzc/N7+QmaO3UQALD0cYaFnPHxJY870F7DKtOv
dzbWvDTU13vPGKefA5/LG+RNAjvurQ+wrpq8nTYhPSMPKMOyipnsFOxT5gT3jvEc
IKi4QwNeWKOYM9Lvp44bawl6XgDWhxIjSFBVbGJcex0VzQ566c6uWqe5smoS9YER
vy1e9Tlb7hBxBRj4HD1TWsHOPqTokXKJ8LZKLLArXNqgBc80ycFBRIWFEUjhecAu
gzsgfpheByPWo3zK4pZCRHu5bQdaeDSeYXq+AbkHsI41wD9rJgyFqDfIEdo8AU7a
ZAXs4w9Cj8JZBlL5/2rjFpc00zbbcQAmnfATlHXW+dkmRP4BXDHF6AXomtbnYhln
Ppyga6S5nURm6+Xo0AcYv8mS2gA9F/9CEjy2im4itgEy3Jj+um04Zo4GUL4RvJOZ
aT/DVFxXpGCVmKjWki9zSmGTQKiWRvtd8VHZrgnZkdldgJr6kxWKwcxi0yZhAH4P
rYZns+iSoeGxyVhIIZdo7bkZqoLuPEqUCDJivDUJthUMYAJfHK1rRUqcwvDlb1TP
33DHQYUpvYsW/urdQfI5wTWUspdjfzrIlhfKsfiuhLm0nr7E40le2Wm01BxB+b4+
VBuTbZAjv5fP7nYeTawJP3/tb834oMP0xsuslK2q0fmmVg79aMtnuhsn/71uUFsH
XGNhOmuGFIsGEZZZUKYP
=j8Ms
-----END PGP SIGNATURE-----

--=-YUwC4e1zzkxfj3XCOQdE--

