Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46381 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab0ATJt2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 04:49:28 -0500
Subject: Re: [PATCH 1/2] cfg80211: add a callback for querying the
 operating frequency and export it through nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <201001200832.48698.holgerschurig@gmail.com>
References: <4B536B05.6070301@openwrt.org> <4B537A94.9070807@openwrt.org>
	 <1263762351.28067.21.camel@johannes.local>
	 <201001200832.48698.holgerschurig@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-t/GswAemvzlPwvSA6eGz"
Date: Wed, 20 Jan 2010 10:49:23 +0100
Message-ID: <1263980963.9171.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-t/GswAemvzlPwvSA6eGz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-01-20 at 08:32 +0100, Holger Schurig wrote:
> > In any case I have a feeling you're trying to use the kernel as
> > a database for something you already know, just don't have
> > quite as readily available as you'd like.
>=20
> I have a device where the current channel is shown to user-space,=20
> e.g. the operator. We used that to find out on what channel the
> current AP is. Or, when the channel is constantly changing, that=20
> the system is still searching for a matching access-point.
>=20
> I know that for both things there are other ways to query the=20
> same information, but it's convenient nethertheless.

I realise that. But all this is complicated with the planned move to
allow different virtual interfaces to use different channels with
time-multiplexing.

> But one thing for which is no other way is to see the actual=20
> channel-changes due to the search for a new AP. If such a thing=20
> would be important (it isn't for me), maybe a nl80211 broadcast=20
> would be better than, thought.

That's actually impossible with a lot of hardware, so I really don't see
the point.

johannes

--=-t/GswAemvzlPwvSA6eGz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLVtGfAAoJEODzc/N7+Qma+cwQAK8AOVx0+Jx8s+r6miXycN0p
svjCGjYeflSkm184esl72f10tTrnSMYU5mosSzwvMMvr4sPR6SFSu4Ci4e/xzFB2
Jo5J3UmfU6HzpC636O9pypdp0O9ZA925AIZrahxTPins9lFAdBQ7ibbL5i18Yi0w
YIDc/yRifFwWRwCwW5AETLpS3UQ/+Q2yIkojhmH+v0YBJtjELQ8Oi9d4FeLlEBbB
lOAfwgdQasbSAPkND+2S0khBOXYKxpvVnk7FUWxfFa4NUG0tJw6tKfZv1zAIfGyU
yathzlHwlIIe8651FVTWOgRzYpqAhfuTtqAR3mqEupxIlfKTyeL//ArOyI62WyNX
SRpMjZ4sf1FdGaHbDtN4MHTKhSm7M8TIXcwb5mbaGaePA3TY6vrwC/QoWFPzX09b
rRR/cIjYiigWIZDUzwBqy3z1rbLj7DfFkkomf8OVyoM1dycC25+NJgwA3Z2SFSQi
aERYLX1eCCZKisXgwNVVClmWpmyxnaOvdkgztXmM+qurkpXWytb11aQCio7cw4Zf
0dQRks29GuucKagOsriol3UMC159CtAzOJ0pNHzY62nz7gnPClzrj5ddIVlo8kzo
hKdUDrx+OpaG5rLPTuNzxpZnPMVqWEcVoioOcT4ce/h0YXW+/qi0Xnvd1i9krNAj
PWOSr6ceVU82BWgIytOO
=PWvY
-----END PGP SIGNATURE-----

--=-t/GswAemvzlPwvSA6eGz--

