Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46774 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111AbZHDM0g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 08:26:36 -0400
Subject: Re: [PATCH] cfg80211: clear SSID on disconnect
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Albert <jal2@gmx.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20090804T082338-799@post.gmane.org>
References: <1249311832.4561.2.camel@johannes.local>
	 <loom.20090804T064513-963@post.gmane.org>
	 <1249370029.9415.1.camel@johannes.local>
	 <loom.20090804T082338-799@post.gmane.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-5oO3br+byrMGqTOlOXsh"
Date: Tue, 04 Aug 2009 14:26:06 +0200
Message-Id: <1249388766.9415.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5oO3br+byrMGqTOlOXsh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-08-04 at 08:24 +0000, Joerg Albert wrote:
> Johannes Berg <johannes@...> writes:
>=20
>=20
> =20
> > Aha. yes, the same assignment is _also_ missing in
> > __cfg80211_connect_result(), can you add it there manually (in the
> > status !=3D WLAN_STATUS_SUCCESS block at the end) and see what happens?
>=20
> Yes, that helped in my case.

The v2 patch I posted to this thread should fix the issue then, and also
fix two more places where it could occur.

johannes

--=-5oO3br+byrMGqTOlOXsh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKeCjbAAoJEODzc/N7+Qma8bwP/2RaRyFLhbpY6nJWeclVi+SE
ViZshBuco/vRq+pT+4Cb2xtxEhuF7q2gYq7jOQbALopdJXaJmLl5NqLY6B3r9duP
53qF0Mk4Iss+qgwDIa+9RCtbpvtlFtXHOi6/fPcjT5jNMQowLTcdnN5QfD0jNxD7
RbqDvptOYKa+C0VZ1fGX6A4/tg4t60kbbx0g+jY4z1MRX+3EcWlD1LfcIlcZFlut
mlc0xzlOWDRUOtbAZe63WavjfeC/SYD7de/zqhIXjjZi7gcwOlxuw940eGtOGvE+
73KWmNSAQanOcXdkp/LyE/wkM5usv9N9ae2mmeWegaTVTIrJUwN0LucJWbpeXwDI
1WLMFLgt0tLDyD/Ptu0NF+CeONaJ/spB/7LXS8poR5u05eW6QinEki3LGgL+M39K
x+z09BFpC3cHTwu4OBqjjB3ZCe9MDRNN/0YHUszqhH6STWW7lcjyjhhuinq1CF59
Eda3cwePlA7acePTyoNAGbXi81uGHhwLQNxaiRaX90scLlnQ1cE0rHRIRoi4kbCS
DgROrIa/F5JEo3uaMFZILI/ZgGBUDmbQFbd9/9c4icMU0ECjYHzTbpndzeU+i3Ne
TxBf9/V6uGAT1PIl/ejW4SW7Vua6v/z9R7Iv4K1RhdBkepCFD79Xxw+QTLdkBch/
lJmLSzQFxusKWPlLvQrH
=VN/b
-----END PGP SIGNATURE-----

--=-5oO3br+byrMGqTOlOXsh--

