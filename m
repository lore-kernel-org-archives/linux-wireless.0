Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48472 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbYJ2Lur (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 07:50:47 -0400
Subject: Re: 2.6.28-rc regression: Can't stop Rx DMA
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1225236760.1115.245.camel@rc-desk>
References: <20081018231046.GA10977@isilmar.linta.de>
	 <1ba2fa240810181630t781468dbi23b103e656f64153@mail.gmail.com>
	 <20081019075916.GA12904@isilmar.linta.de>
	 <1225145468.1115.139.camel@rc-desk>
	 <20081027230326.GA23250@isilmar.linta.de>
	 <1225154823.1115.149.camel@rc-desk>
	 <20081028194323.GA14303@isilmar.linta.de>
	 <1225225434.1115.217.camel@rc-desk>
	 (sfid-20081028_212343_098446_12401F4B)  <1225235731.1369.8.camel@johannes.berg>
	 <1225236760.1115.245.camel@rc-desk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-++ZPY7JBm3AbhSFWC8rk"
Date: Wed, 29 Oct 2008 12:48:41 +0100
Message-Id: <1225280921.5439.2.camel@johannes.berg> (sfid-20081029_125049_901987_36965921)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-++ZPY7JBm3AbhSFWC8rk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-28 at 16:32 -0700, reinette chatre wrote:

> Without the regulatory information the number of 5G channels to scan is
> zero.
>=20
> > [ 1094.582562] iwl3945: U iwl3945_bg_request_scan Kicking off one
> indirect scan.
> > [ 1094.582574] iwl3945: U iwl3945_get_channels_for_scan total channels
> to scan 0

That, however, is a valid case either way, if I move to a country that
doesn't allow using 5 GHz band at all, or not those channels that your
SKU ships.

johannes

--=-++ZPY7JBm3AbhSFWC8rk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCE2VAAoJEKVg1VMiehFYtBwP/24aYSvjzQp1NCYb5dhvJ4cO
hxQBxba9rM+o3yXk+auM1A1spyKRGmekRcrnxr31UqlpShD1zFqACEtkEjj/R55d
qqzfGzfiNo7PUxgnBtYrlzwll7NxAVEaK9YngvRJLs8l+APrU+wjQrtTLKiFPnpN
3hjGaVwVfJCdV2f5FEGxStfESOhI33Z1cZp1W9v8c55g8gWrdApmEeAYCbFUd4/+
HBAkWTcvyCwo3Pb8wC8I3LT57djU6w5lv1nPOXsbXThAAe24z/6GFbafioh2MbjB
QgXYid6sOLSqwMUqJW2HoH7sQJwm0AOfvDcoZRNRt12T4TmKXJFEw7Q7OHLu4Ghi
mmOSeSPQgESbwr3OafYGtH9kaapvwI47dSAgA9hD/M3qxxI0VuXIUEgqwdeq5AGA
PpYn7MM/T4nIe/iC1EFFWFhzY+zp94w/XUi44rccLFy5d8DHwgy3yC2/DByOfEH7
uLRjcCSQ4YTZtGhtWxp+vIJPw2NgmvQON0bj+VaAYaddmx+xXpASRsz3J2YigGKz
z9FjibZETtKjOs/pIJ+piF7+iT+AFEMX6V3d800iwvXNWEUwQrMvQrSYBD3jDgMC
m+cg8RzqqtAo8pTrNYoCgkw3KsWeVP2uFqsj61dx7HIH90zqaKXtg2G7FWKGNTsM
oaHOjI3Dk8JZJcsuh823
=At/O
-----END PGP SIGNATURE-----

--=-++ZPY7JBm3AbhSFWC8rk--

