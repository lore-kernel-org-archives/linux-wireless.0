Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53247 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbYLJUqQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 15:46:16 -0500
Subject: Re: [PATCH 1/2] Add signal strength and bandwith to nl80211station
	info
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@googlemail.com>
Cc: Henning Rogge <rogge@fgan.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
In-Reply-To: <200812101840.32146.hrogge@googlemail.com> (sfid-20081210_184036_166802_3C0157B0)
References: <200811252131.30161.hrogge@googlemail.com>
	 <200812100753.58590.rogge@fgan.de> <1228899950.1029.33.camel@johannes.berg>
	 <200812101840.32146.hrogge@googlemail.com>
	 (sfid-20081210_184036_166802_3C0157B0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6ltLO3pavlw5+UntCCyv"
Date: Wed, 10 Dec 2008 21:45:37 +0100
Message-Id: <1228941937.15837.71.camel@johannes.berg> (sfid-20081210_214620_597346_A5350AA0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6ltLO3pavlw5+UntCCyv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-12-10 at 18:40 +0100, Henning Rogge wrote:
> On Wednesday 10 December 2008 10:05:50 Johannes Berg wrote:
> > Uh huh, it's a huge table, and very irregular. Not very inclined to cop=
y
> > that right now. What's wrong with deferring it until somebody actually
> > implements these rates?
>=20
> Okay... I will try to implement a complete version of the function when I=
 get=20
> access to the table... here is a modified patch with two warnings about t=
he=20
> missing datarates. It will return 0 for mcs >=3D 32.

Can you do what I asked for instead and not include the attribute when
it has a bogus value?

Thanks,
Johannes

--=-6ltLO3pavlw5+UntCCyv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQCptAAoJEKVg1VMiehFYI50QAI34EV6zwqoyXuhSv4nPxWqJ
/IYNi9Yiq916ma8enyLdS86XJMa/X8oNoV+yeTzmil5VLvAPVLjOC5bBeDbJN+2j
MKznznotnEq7E5AhrBVdAle5ID5XpTaJ4m5QfYKS3jTBIm1x2T4ggagpFEeSMooa
ZfuwE++2mx11iN0EuhO5Nesyxh+B6sfKr0vxL3hReRfxdTQ+1YoZu3isZpbJfMmz
a/EPt9gVNWFZV4bzD9iGH5jDJjWVRWyWW8j0EnhhTn8A9UPTL93Vf8P2oaSo7ekl
tfsUdqOlA5CyVnSQFNyYv9UszXe/rEOGOzkk5GUIec4ZwqaR6L+NE1eQE5GnrNeE
qJ9Sgh3NCTJnx1rDkJ4fhIswWtOyAF9scsdo7SOo7DHKMS/OZNmlp9myLCdEBLgM
iswrrsZOwCI6vlHkiR8YoAueHGJq7UFdh8uWtaJP+sx7Fi0cokWdulHCd25wCJOG
Wce6mHmcyczT7vQjF1V4/34zFszGPFaYGpKDemtcEmao8X/boPqMO510R5yyL7ur
Gu85SH/1dREx4ywg3ZGqYMoisiP3fCiYnP/wya4pj/Jni2GvJXGGdMw/4QhnOITy
zA67DpoGk96smRwn2QJwfX+A3ffORaDy03pRyJrun1RrTKUFes7ORZ4Af87EAKsh
pWY1Hh7b41mcmD66E6zY
=rJOo
-----END PGP SIGNATURE-----

--=-6ltLO3pavlw5+UntCCyv--

