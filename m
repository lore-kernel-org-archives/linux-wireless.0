Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35961 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbYI1QTh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 12:19:37 -0400
Subject: Re: [PATCH 1/1] mac80211: send action frame when toggling SM PS
	mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1222618493-19019-1-git-send-email-tomas.winkler@intel.com>
References: <1222618493-19019-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-z8EKpMBOjO/4gptsT1J0"
Date: Sun, 28 Sep 2008 18:19:29 +0200
Message-Id: <1222618769.7064.0.camel@johannes.berg> (sfid-20080928_181949_544577_58025ED2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-z8EKpMBOjO/4gptsT1J0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-09-28 at 19:14 +0300, Tomas Winkler wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>=20
> This patch makes mac80211 able to send action frames when toggling
> (SM PS) Spacial Multiplexing Power Save mode.
>=20
> Example:
> 1.
> Low lever driver may close some of RX chains in power save mode
> and needs to announce to AP that a RTS frame is need in order to wake all
> RX chains, on other hand SM PS can be disabled on CAM mode or if HW is ab=
le
> to wake all chains without RTS frame.
>=20
> 2.
> iwlwifi can call this function when it detects that only
> one antenna can effectively receive then MS PS mode is set to STATIC and
> AP is asked not to send MIMO rates packets.

Why is the driver managing the PS mode to start with?

johannes

--=-z8EKpMBOjO/4gptsT1J0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI366OAAoJEKVg1VMiehFYlsEQALvwHE03XaPM0luWvasloMqr
DNzVHSo4DuK0oJ/avNE3y9o/BvHwJD/+PELBrdtnVvUMzRiVP10zQQkBc6kb9l9I
TDBsPF+TZiHD7Ydy1AMxs2/kiqdiJr+KVFU1c3vjA4NBq5dnwjdEamsmXihCJxSu
wwT8RzjpHcWhoDP+7dcxhBvuD5h1Y1M3DDgq252u0MS3Zby7jBeuZJw2aCfwe7fR
O+jzb6p3cXeoZ/sa8/7PpI5g0VzZKy/jGyqJV5a7aiI4qoznY4YZUOYgAvkRBNpg
ZVtPcTsPHsXr/ALP3jju8WpJkkmjGD7ye6LuIkj2G69+7DaS2f61sjIwgVsZhUYO
GXMhe8WdlZ7/PufZKqlJ9C7jlWq9UHtm317iBtPFqu/IJlFqC8xxpErvwBzAZ2sP
Ey1VgDkHSFTHyq8MkfiivVsVFZYPrVi8WK/Dzq1s73y9oeg6DQ4P7FQQiSCbEvgg
RZFSTNIlYumJuvVDj0hY6OoLTL36w3h95zQQ2TyjCZ9Oi+OHNJTkf13UnhlgkjEQ
HUZxE6bZcf/7hIeJ80I4mKgLOQyM+Oz5ElFDPjIdUBzuxPBlSBZLtfPjo3Owqd2m
TEbKdECHS1Jck0S9+1XnD98Qy8ogA0VIqT1rBZyD8KTSkeGxkQbOjYAFJpx/B4ZM
sbOBRWFaGcH7zqRwsfKC
=mZHg
-----END PGP SIGNATURE-----

--=-z8EKpMBOjO/4gptsT1J0--

