Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34762 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbYIZL3p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 07:29:45 -0400
Subject: Re: [PATCH] mac80211: Fix oops on wme.c where mdev is assumed to
	be a wiphy
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1222426319.10563.91.camel@johannes.berg> (sfid-20080926_125214_316470_E94EDE4E)
References: <1222419687-7106-1-git-send-email-lrodriguez@atheros.com>
	 <1222426319.10563.91.camel@johannes.berg>
	 (sfid-20080926_125214_316470_E94EDE4E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fSYrJO6NSurPbYA8DT6m"
Date: Fri, 26 Sep 2008 13:29:34 +0200
Message-Id: <1222428574.10563.112.camel@johannes.berg> (sfid-20080926_132948_627922_A6579BA3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fSYrJO6NSurPbYA8DT6m
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-26 at 12:51 +0200, Johannes Berg wrote:
> On Fri, 2008-09-26 at 02:01 -0700, Luis R. Rodriguez wrote:
> > After Johannes' patch which set mdev as non wiphy
> > there were some remaining bits of code which required
> > changing the assumption that mdev was a wiphy. We
> > change two callers to get to struct ieee80211_local
> > the non-wiphy and actual mdev way.
> >=20
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>=20
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
>=20
> I _really_ wonder why I haven't run into this. Odd. Thanks for fixing.

Damn. Now I know. I forgot to add these changes to the patch in quilt!
And I have another one too.

johannes

--=-fSYrJO6NSurPbYA8DT6m
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI3MeaAAoJEKVg1VMiehFYI7oQAJzmCmiKkDaq5eG8G2uV1xsv
P1+V5SaUg4bDPvhz3Kl/ZzTFCAHIOSP4T8f3sJt2ymM8hhDMvR7zyR5hsQ/Ne8ma
P3XF8hYfy9SxGSGoXNqZMsrUxLFjS4TjKCx9PBMOAVT9pdjbnWEYPX8+zcBzmrSK
m9RTzsomrPmO+OFCU6j8J8RjrS7eVUaE/2IQjv1AZfF/uVppZ1eTDuylqtAlK13V
AMC1o593fyDS8zKOT/XkJb9FaFtVM0dI5f0BTatY/hVxdMX8fyNxcB0bWOmtGMpK
S+/PSgcHPX1q8vVjUHCjnmRbCuI1pEY426TADorH2JPLhjGMimrHh3CeCD2ztXRa
mvNXQSHjulrUcOqCu5ztmplh5qE4ztUljF+Zng0cYlXyLsrwfQt0w9GVs/UnvDfT
cEqSVFhgT6qS1y0w1ZdEYny38KLDBn5tjQG133reUVyGABzZHS4tSgb590w41BPY
YLrxZkQDufTBfFZlcnlh4gzdl1SIMfG0lAFYJD3T0xIIrXRVXh5upxAesSXBLkWN
aFEQaZT48JuQ6GreHYYTT1NEs3kdy37bmhustO3w4WXGKqpRKmScem8TigZAHEC9
J1iM1cqHJLC0iFDoDGErbpFIEQbwCoqejAgYUpSZIao1KBk0pc/0GsXliAEt/Pnd
hHFyTMmQOu652CZaQj2o
=VOgr
-----END PGP SIGNATURE-----

--=-fSYrJO6NSurPbYA8DT6m--

