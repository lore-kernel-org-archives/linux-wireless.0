Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56520 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473AbZBTAWU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 19:22:20 -0500
Subject: Re: [PATCH v4 00/15] cfg80211: add a workqueue for regulatory
	processing
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1234999545-14357-1-git-send-email-lrodriguez@atheros.com>
References: <1234999545-14357-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WF+SHd8qFbz6Gfc2Ur2X"
Date: Thu, 19 Feb 2009 14:29:31 +0100
Message-Id: <1235050171.4023.64.camel@johannes.local> (sfid-20090220_012222_577108_18B37332)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WF+SHd8qFbz6Gfc2Ur2X
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-02-18 at 18:25 -0500, Luis R. Rodriguez wrote:
> This series has a few cleanups and minor fixes but mainly
> adds a workqueue for cfg80211 to use to process all regulatory
> hints. This v4 just changes the spin_lock to only be held _only_ during
> dequeing (not like this matters much).
>=20
> This series is also rebased on today's pull of wl. Using a new
> SMTP server now, so hopefully this goes through fine in one shot.

Except for the unlikely(WARN_ON()) which still looks weird, this seems
ok to me. I don't know why you insist on having a wrapper for
wiphy->wiphy_idx but it's ok :)

johannes

--=-WF+SHd8qFbz6Gfc2Ur2X
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJnV64AAoJEKVg1VMiehFYYEQP/j7adlems0SmTJRCw8z2j9Wn
kRlE21fCS6y3Wqggmn9lu7v9uDCush4oouqZdAdRYtjHz6Z+W5XQZ9twD5/lwqgA
FYEtPJL86kiFM11hyB5j5BOpyCyf216jL3IOyUqhl1dKJROs2LxXJGJjF8f28zLP
p/EXgx3n96oOvgp3DsC1zSCbHPQAS0pNp2DEXJBMEEgsBxR8dKjZXcpmW2s3mAeC
uJps8vdYYpncIBJ2EhR+PKEstXt+2XtqtxvhdJTCXjNsj9AShtbXWUWOwiWLqQsJ
KgbKV2rpy6rdyuY8BNKFhugbHSkN5csZc8VVLgGcwDdXxpKSdZgzbEULcPJr/7/X
D4NCee4fluEN6s9k3R/gZ3Xgu92YFy+JEvR3aOhQL2cMQ3FSroqHbZKYQ8WnS1zY
dZIs51cRDz79oYvrET4TONx3PDkGoF1FAI/Q1P3zwYsMm8hlhdhmWGsCZd+2V1J4
kMJoFi2sKtUatz8QQ2U2XXPHAuEMplyGafLW2HVK46X/qQJkpqzVjclEz+jUKowl
1XQL6BfeZOiXsmXf/nT0gD/fe8/iBMcWHPk+wzHLPKI9u8ABkzp0rbo59R7VzOVM
jQzL9ykmTTKNsJl3NfQc4dTKKKIus2q3WFkiU3RWMWPf22cuBEOkxRyYZcisx9JF
vO6KNsvaN7j8XbSHneAV
=f0EO
-----END PGP SIGNATURE-----

--=-WF+SHd8qFbz6Gfc2Ur2X--

