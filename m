Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59148 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbXHGJuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 05:50:16 -0400
Subject: Re: [RFC] bcm43xx-mac80211: Hack to turn automatic pctl off
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
In-Reply-To: <46B7F9AC.10706@lwfinger.net>
References: <46b792a0.FdNEyH1qMrUgo6oh%Larry.Finger@lwfinger.net>
	 <200708062335.48546.mb@bu3sch.de> <200708062356.58782.mb@bu3sch.de>
	 <46B7F9AC.10706@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ddJ0tQLd016M8XDh9iAg"
Date: Tue, 07 Aug 2007 11:51:48 +0200
Message-Id: <1186480308.4067.33.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ddJ0tQLd016M8XDh9iAg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-06 at 23:48 -0500, Larry Finger wrote:
> Michael Buesch wrote:
> >=20
> > That's it
> > http://bu3sch.de/patches/wireless-dev/20070806-1186437386/patches/bcm43=
xx-mac80211-hwpctl-optional.patch
> >=20
>=20
> This patch makes my BCM4311 positively hum even with the power set at the=
 default 18.5 dBm. I get=20
> the same performance as was seen using the PHY code ported from softmac. =
Congratulations - you found=20
> the secret. Of course, the system will probably be even better when hardw=
are power control is=20
> working, but we can now afford to wait until the reverse engineers have t=
ime.

Cool stuff!

johannes

--=-ddJ0tQLd016M8XDh9iAg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGuEC0/ETPhpq3jKURAk9zAKCdrZ0sdtV5xmIE4TlcpBXFihzfXwCfcKVe
tL42LINm30ktsnHwNf/CM/o=
=+eCu
-----END PGP SIGNATURE-----

--=-ddJ0tQLd016M8XDh9iAg--

