Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33191 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759059AbYJJSmr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 14:42:47 -0400
Subject: Re: [PATCH 2/8] mac80211: remove aggregation status write support
	from debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Tomas Winkler <tomasw@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <45e8e6c40810101139r3fd97443n7171e8a29862098@mail.gmail.com> (sfid-20081010_203933_091584_D02D1536)
References: <20081007100428.868688000@sipsolutions.net>
	 <20081007100438.773792000@sipsolutions.net>
	 <1ba2fa240810071424s23bdbbb7kbaadf3678cd61a26@mail.gmail.com>
	 <1223452772.3618.20.camel@johannes.berg>
	 <43e72e890810101122o12440c60ic35b19b037bf95de@mail.gmail.com>
	 <45e8e6c40810101139r3fd97443n7171e8a29862098@mail.gmail.com>
	 (sfid-20081010_203933_091584_D02D1536)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HBvS8vnK7kmNMtOBN1Rt"
Date: Fri, 10 Oct 2008 20:42:43 +0200
Message-Id: <1223664163.3748.36.camel@johannes.berg> (sfid-20081010_204333_095415_08841904)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HBvS8vnK7kmNMtOBN1Rt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-10 at 11:39 -0700, Andrey Yurovsky wrote:

> With the current code, I am not sure if it's ever intended that user
> space has the ability to initiate and tear down BA sessions, so this
> may or may not be useful to others.  Right now I am using them to test
> BA initiation and teardown and I suspect that they may be useful to,
> for example, hostapd in the future.
>=20
> Please let me know what you think.  Thanks,

Without looking at the code, is this really useful for much except
debugging? Shouldn't the rate control algorithm be in a much better
position to make that decision?

johannes

--=-HBvS8vnK7kmNMtOBN1Rt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI76IgAAoJEKVg1VMiehFYNuMP/jP1cp4Vhy/lGUm4m2y4sA4r
X5Mf5s22aPqQL9bTSF5IUzX4+HSsUj5uTwURfiO+qoq2AAtg5BNb+2uE4MvawK6W
DaRZIgIFp3SqLEU+TKHg9ApLzZTEavQiUK3HqLGudY4gtIn2dyInsg9ZCFvkvucF
dT3dXZRYd0gZYPMmug9EbKPAw9RXKV2VmPCtYOtm8kcV1Ytcw1lqke6JbT93A9FC
StgLbQazBHjlOuRDXr7yFQZ9zefqC5C1SDsjMypvfwchJ2oIaA6/VzTJF0I/acDB
CfhJb6T/CoMoffWMm/q+cKke4vcwhNukb7fff1xrE2vTR9TE9jpsTMZXiJ2PixX1
5zXWK+h3ZwVr1lktI0vLECMG1QZZDC3jJ/6wFVIssSsPzCIon6SX6oDwn9/2dlHX
asEpBUfIERlx797j/K0vIljD+kZkMbYPaAEQdg2U3MSW0pMGKdACytN9MlxwNvSX
LJcB5/AoT/t8MFgaeZL5IFuMREQYTu02SKHN035Rk0tNoeetbWS85yUtqIBEB5zN
GScRs+C4g1tYxv+HsjDyYSXo7hRq/hrWn0/wTfWNklEJxqViANQW2K1q3ff+hgc3
lrJsCUvgXEzWB6SbrDIPYmrZ9Q13+en4LAQoZQZqVOsw1Rx3WJakQo54LzO3h9rZ
JTT56jZiTpDi0UK/S3/w
=IUow
-----END PGP SIGNATURE-----

--=-HBvS8vnK7kmNMtOBN1Rt--

