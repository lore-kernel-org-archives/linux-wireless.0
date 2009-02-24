Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49493 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbZBXFRh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 00:17:37 -0500
Subject: Re: Signal quality strange since commit 708c57cf1709fb95
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kalle Valo <kalle.valo@iki.fi>, Dan Williams <dcbw@redhat.com>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <49A37531.70907@lwfinger.net>
References: <49A01922.1090106@lwfinger.net>
	 <1235241867.3284.44.camel@localhost> <49A05E35.70904@lwfinger.net>
	 <8763j33rgq.fsf@litku.valot.fi>
	 (sfid-20090222_074023_562332_D346678B) <1235441441.4455.58.camel@johannes.local>
	 <49A37531.70907@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-g5ckMG19HlH6bleaVZd6"
Date: Mon, 23 Feb 2009 21:16:15 -0800
Message-Id: <1235452576.4455.81.camel@johannes.local> (sfid-20090224_061739_919533_57A19FF2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-g5ckMG19HlH6bleaVZd6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-23 at 22:18 -0600, Larry Finger wrote:

> No, I just wondered if it was intentional that it was changed to /70. It =
appears
> that it was, therefore, at least 3 drivers must be changed as they are
> calculating on the basis of /100. For example, my b43 is showing an iwcon=
fig
> Link Quality of 93/70 while the KNM applet is showing 50%.

Well that _is_ a bug, since this shouldn't have required driver changes!
I'll take a look into why that might be happening.

johannes

--=-g5ckMG19HlH6bleaVZd6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJo4KdAAoJEKVg1VMiehFYW3AP/3E57MLyI2DeKM1JgbRMRpEP
C1KrUTispksZMa8mBWr4Hr6VscCzdFmlcybCuEXveQnzQasiPNQXOdeCHac8jtiq
ZTiLVOQLkN4KPWkgncsEQyY/MhBCS6zss13VclmJI5jjgJGVawEKcybYhagJwofr
Dp9E7kmmu8WWmmfzhQS+lfDKB3oHLtVp6WY8fNHW2ZcMbuUKpaaO90Dh7V10LvU7
V5fV4NluC/JhGGzd8pWt5A2/OlNlHRTGabhN5x64FhMyxRkEINZNXnjjokaYl9yu
/oF5Ky+7+rRCxzoS/HcTEK/bFtU62GN077r4zMXlFNdV5piAZGkPsXlOFiYAmWzp
pG4z55Du4eJMfMGsIhuWKNEADXC1JyWx18tZHeQGP1gUnk2ZWTzxm+2j2/m8CY5r
8S+fOMN6WRifffTxOiBi83II1quRc+t7y3mnUb0mu8xFbCmA9A2YgpYOwx+cFQJf
EE+0ch+VXKB2XcUTZDhFGJUek1ztIq24Ejao77xvBhkwr8xJ0/dL6AYSoIDcebP8
PTMPRNqnjy4UiRaggIUlTR4qFpWxjSdLftMRJ3JvNLPsWIpKWPxWDt1Mck2uuwXV
9K3fqXYV/yIAF9v348/uZgIQDeXyUvIeUntc0O4nCXWWqRfKbRigh7/Dc9MjOXyt
PHoYF5cMjb/s3Bas5FuD
=vUUe
-----END PGP SIGNATURE-----

--=-g5ckMG19HlH6bleaVZd6--

