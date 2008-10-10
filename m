Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50247 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460AbYJJJRs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 05:17:48 -0400
Subject: RE: HT capabilities IE
From: Johannes Berg <johannes@sipsolutions.net>
To: Nils Bagge <nbagge@bandspeed.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <6EACAD9615B47B42A780C005414307E1014956CE@mars.bandspeed.com>
References: <1223460098.3618.53.camel@johannes.berg>
	 <6EACAD9615B47B42A780C005414307E1014956B2@mars.bandspeed.com>
	 <1223546085.22490.29.camel@johannes.berg>
	 <6EACAD9615B47B42A780C005414307E1014956CE@mars.bandspeed.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0PgSlI5OXh2Asc+Zr98J"
Date: Fri, 10 Oct 2008 11:17:48 +0200
Message-Id: <1223630268.3930.75.camel@johannes.berg> (sfid-20081010_111808_446784_00A73B77)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0PgSlI5OXh2Asc+Zr98J
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-09 at 10:41 -0500, Nils Bagge wrote:
> > Right, but if you enter dynamic SM PS then it doesn't matter much
> > anyway, does it? I mean, there's no protection requirement in that
> > case, is there? Or am I reading it wrong? I _think_ I will handle the
> > SM PS change in mac80211, but I'm not entirely sure right now.
> >=20
> > Johannes
>=20
>=20
> Well, upon a more careful reading of 11.2.3, the second paragraph would
> seem to indicate that some kind of protection/wake-up is required prior
> to a multi-spatial stream transmission, if the receiver is in dynamic SM
> power save mode.

Indeed, I was reading that as "beginning of the frame" rather than
"beginning of the frame sequence". Sorry.

johannes

--=-0PgSlI5OXh2Asc+Zr98J
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7x25AAoJEKVg1VMiehFYyFsP/j1oQx9AOxC6FmExmAL2PkgV
B+Tiu5qn8FN1MQKyKF/U6xqmPn7q9uQeWsv8vjEdL4ljGWA9Sl56STLM9OUmx4so
Acpbg1u78JoYLA25Ua4/U73UvZUdgKWuTXk96tr2y+0dK6BCqrQ+Mwy1p/Md1zV/
pdqq/UWd80dqgKhR3aInawgFeYLcUd3yaPelxRTuxd6BVJ6jyS1WM54ieVR/s6bo
7w+MwD7f3V/uUUXhAZ7GfSK/Kh2feZ72/kEvumCVJGO9wTLThtZ8H09gAw+WOOg8
nyzVOlSRrcFuAlpcKluHBeo3tMwoiCJo57XiBl1HQj4E19pIVYfzQKMvZKuV8ir1
Pxs0HN2r/4mZkmtu/AMtzMQxKnC7JHI+lXX7s9mMQUlhepMq5OB7Odd2FdH0WPfA
H6VT7E9r5b1v4pWOanmx8+p1vHSgNB3hotIRfxau/CLOuKqLvxfEs0hPwbe20h2J
qegGDLRvYHYz9r3G6pk4HRcAMLitbgt5iQGHSCAfK+3zDhl7mlGblT2a6KTQPct+
8g1eIqJSCkW/kMA7/2lt5/I5Y7v3Jhm43N1SgHx9v81+w2puCYITKfNF/3s3bw5f
eepNhTcdsd51I0dAWuxzw5BxLeKfj6+9sDenjsZzssG0ha9/DUcFS5Vtr2XE/q1j
c/7UFQraAnHU16kiQUjg
=TSrr
-----END PGP SIGNATURE-----

--=-0PgSlI5OXh2Asc+Zr98J--

