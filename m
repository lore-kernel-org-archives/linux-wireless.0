Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45991 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbYI3SqJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 14:46:09 -0400
Subject: Re: [PATCH 2/3] mac80211: add multi-rate retry support
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48E20C5B.4000900@openwrt.org>
References: <48E20B7C.2040405@openwrt.org> <48E20BFC.6040904@openwrt.org>
	 <48E20C5B.4000900@openwrt.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+J3IKOKBeg+xIVHa8NvT"
Date: Tue, 30 Sep 2008 20:46:07 +0200
Message-Id: <1222800367.7064.64.camel@johannes.berg> (sfid-20080930_204613_586432_4DA11C0D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+J3IKOKBeg+xIVHa8NvT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-30 at 13:24 +0200, Felix Fietkau wrote:
> This patch adjusts the rate control API to allow multi-rate retry
> if supported by the driver. The ieee80211_hw struct specifies how
> many alternate rate selections the driver supports.
>=20
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Would be good to look at all the drivers and see whether they currently
use the retry rate (set max to 1) or not (set max to 0) I think.

johannes

--=-+J3IKOKBeg+xIVHa8NvT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI4nPrAAoJEKVg1VMiehFYIFsP/3roTaTjV7ASeksZppYeudML
gi2FhQoauMwv7WXXJ4cxQP34Yk/BMoOn5i7W2+6Fwg3auZxjzarYUDXhProeeiZc
PegnIL42DUiK3TQhsk4y2nH6Yza5RlPIDu+3ziOu0AS8TEO46grhpv/nSfgxP43B
cCEFoi9FXx4ei1/kJ6DgSVAsBXBCOoy9etkWmfRZuE9w6n9VLCDktJjyUpJaHkHZ
z712jihiouKIqRRh0X/yj9CvsoEY/XDq/qvz89jiftmntiwSP9NQhw8tKsLJAB2j
DeVZIAIh0AsvF5xd6VBVaOHTsyK3jZMVTEwu0cdkZtM++3gJD+Yap/7InYUkW7ay
KQ00qWYI69EATcHXGsbs/KXlyfU7AT1oJOjOUtPmi8+hNnxOQV9CbU3slR5aCdol
5iU7XpaX1ESMiV5ZhtIIH/JU9px2RhEIBWG+15ZULawfFTlbBLxtG9FClMH6yj0T
POF5gStH9VRLiE5jXshg1wS1t7wz+P+VJoQYLsUbrcWHAd5Dz3BeIcKEocKlqjPE
XGl8Pb+D0Q7y68Y7yUnvSCpqq9TVP3PjlkQESdmQi+hNB7YN3W5XcHLMMmmxnBZE
ygPDyehGmvBlOp8gUp1eA+2KaRo+fvXUsvSTWIaeT2AogdY62Uk8zKAi4hJk1QMa
R7y2T+LYbYNbPeGXeR5v
=RpAG
-----END PGP SIGNATURE-----

--=-+J3IKOKBeg+xIVHa8NvT--

