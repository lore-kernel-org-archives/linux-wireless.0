Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35206 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbYIPSfP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 14:35:15 -0400
Subject: Re: [PATCH] mac80211: refuse invalid interface configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221589924.8916.52.camel@johannes.berg> (sfid-20080916_203323_424249_F57B27E3)
References: <1221589924.8916.52.camel@johannes.berg>
	 (sfid-20080916_203323_424249_F57B27E3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jJVUIBArT3tFxnwW3oo0"
Date: Tue, 16 Sep 2008 20:34:24 +0200
Message-Id: <1221590064.8916.53.camel@johannes.berg> (sfid-20080916_203519_724938_2EDA4ECE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jJVUIBArT3tFxnwW3oo0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-16 at 20:32 +0200, Johannes Berg wrote:
> Refuse setting mesh_id on non-mesh or monitor flags on non-monitor
> interfaces.

Hmm, know what, ignore this patch, I'll do it in cfg80211 instead.

johannes

--=-jJVUIBArT3tFxnwW3oo0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIz/wsAAoJEKVg1VMiehFYPyIQAIKKQwrOIYbhgDEOCANT1C7B
QB6tcbO2UZlhxKQXnqgGOpUKbjZuAe8+T2zQd5KXnAzld0ABOKOqsA3qVftMaFdB
q8ilK4uZ4IKzR8xc+TNF5Tw2j1CIMpsO50wdQzVe9mCBNmgLU/xzQ4Bc8zsUkUlz
iJMl+wiNaJZR6+t79TtSuxcCO8ZGejxdxK87B2Yfp3++yU0omSCCtFCppvmnWyfv
MU+uOJmznhUfSzw9iarKdjMVR8k433qMaza4oTW9L7VEG4B9mMwz9efj81OXgx+r
MHyR5xPEEhzWxyuDQ0/YgfA+/xkw9mTItiMAYYpV5bk+kMqS/FF2arXyBvsynVml
t0QnX9i5nRnxRHjWOApk94KX8Uc5nka4eG7ZKZuYMuU4XxZwtCUaI0kZdZKSeN9Q
Lo8789YtnyMTI09kP0VNSlhdVJ+X1U0h4p+U91skeD0mZI8T2/NdzUuzP5gSpgwn
ylLZuY/2DI1lPrxT3MooASpZFA89hOcxR+oj5hm6zRYoprhqYEvmaDFMKhXOWaJv
NwSOx0nU1jHLaRyzeKAB4wHjvQFUBWXUKONuQlKxegpESSxy2GMet32fHPm4eFLB
IreMOZAhBhqSzPXQ+s8FLDd7CDjnWhykmmJG0VSitXIIc8L4NnNRrn1sm4Hdy2wG
dpT4dSqJsrGDKr8BdlLF
=2fle
-----END PGP SIGNATURE-----

--=-jJVUIBArT3tFxnwW3oo0--

