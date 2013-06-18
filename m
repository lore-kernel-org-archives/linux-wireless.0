Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from diserzione.investici.org ([82.221.99.153]:46526 "EHLO
	diserzione.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab3FRMoj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 08:44:39 -0400
Date: Tue, 18 Jun 2013 14:42:37 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: Re: [PATCH] nl80211: allow to register for mgmt frames without a
 matching pattern
Message-ID: <20130618124237.GC1124@ritirata.org> (sfid-20130618_144443_712436_2CECA62A)
References: <1371558554-367-1-git-send-email-ordex@autistici.org>
 <1371558772.8318.11.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="JP+T4n/bALQSJXh8"
In-Reply-To: <1371558772.8318.11.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 18, 2013 at 02:32:52PM +0200, Johannes Berg wrote:
> On Tue, 2013-06-18 at 14:29 +0200, Antonio Quartulli wrote:
> > From: Antonio Quartulli <antonio@open-mesh.com>
> >=20
> > It may be the case that a user wants to register for any
> > frame of a particular type.
> >=20
> > Allow this operation by passing null as matching pattern and
> > 0 as pattern len when registering for the frame.
> >=20
> > This is useful to wpa_supplicant when it wants to receive
> > any AUTH frame.
>=20
> We can (and do) pass a 0-length pattern, any problem with that?

Hello Johannes,

I did not know that netlink supports 0-length attribute.
Thanks for the hint. At this point this patch can be dropped.

Regards,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--JP+T4n/bALQSJXh8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRwFW9AAoJEADl0hg6qKeO+dAP/2A2e7UAG3BPomGXfSMv6cwY
JkvqJ9QQg+/x3IGYlS4DKzRrUCr72TLWmZABUPZeUOzSIOwxK6yVsY+dUfZ+9zo0
u7UaUcIZeME62v0nHJp5KL6GEm3M1WRlWA3IuKC5wba63aPeuzvu8MjB5G3Fe5MU
w5cozE4UAIwzIwWmO08VbHbua6GQa1cTn7MtASjRQ+h8X3dYxdItLhA7+/h+mHQR
TrfTVrxwqsRJpyY5KVaAfDcBQsYKJDY1/aoT07KekU3VQ6/sYOJWPMBjN+zBGcjD
tyadVSjVw5nMJClkhTX8pg2PKerlAwsPjbjJK4++6V74uRBeTqr8A4j+gT62h6LL
RpopwagOwZOxMwFxsCeG/PI+a8iihGwqOa0qTt+sYJSWELqaKmmiVhfHaazZzRCv
e5gwMsGOPKkGcaSEUJUAlpX4mCUYCGkdvZunpl3WJDXmSZamJ1K/LdgYXPPsa0iT
0aB+Z/7DbJNk9ZzPB1r9vi4dGJib3pZ2jqFevas2C10z0zpmL2D391poSfmvNcXq
JX8Bol15ET2ctLTa4ipGh1Ec08TMKrwqNIa7l9Y7qmT/5OrjzWEI9wU2j70uC69Y
vBLgTo0oSrZLFITlHbwM47GwFaQ7s9yEbjLO+4g1DDtEF0ad6byUQxdVBVAGzmSk
MoYRjijyq4vzeqp8opSO
=gm4G
-----END PGP SIGNATURE-----

--JP+T4n/bALQSJXh8--
