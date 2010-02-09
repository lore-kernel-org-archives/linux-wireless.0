Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49329 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab0BIH6q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 02:58:46 -0500
Subject: Re: [PATCH] nl80211: allow adding new station to devices in mesh
 mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Javier Cardona <javier@cozybit.com>,
	linux-wireless@vger.kernel.org,
	Andrey Yurovsky <yurovsky@gmail.com>
In-Reply-To: <20100208202643.GA1420@holoscopio.com>
References: <1265331642-27773-1-git-send-email-cascardo@holoscopio.com>
	 <20100205165726.GA1496@holoscopio.com>
	 <c1545bb51002050947q707bb5ebud5ec7b4680f49ac5@mail.gmail.com>
	 <1265446793.4041.2.camel@johannes.local>
	 <c1545bb51002071151wb2cefa3mb03501e0d6b3fb4b@mail.gmail.com>
	 <1265620089.3783.2.camel@johannes.berg>
	 <445f43ac1002081125i61bb53dap5b9df374b3116ba9@mail.gmail.com>
	 <20100208202643.GA1420@holoscopio.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ElJ/JcpkBWisuxUo7r24"
Date: Tue, 09 Feb 2010 08:58:42 +0100
Message-ID: <1265702322.3783.18.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ElJ/JcpkBWisuxUo7r24
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-02-08 at 18:26 -0200, Thadeu Lima de Souza Cascardo wrote:

> > After reviewing our mesh test suite, I would vote for disallowing mesh
> > point addition via iw.  We currently force topologies by 1. turning
> > auto peering off, 2. waiting for neighbors to be discovered and 3.
> > controlling peering with 'iw ... station set <MAC address>
> > plink_action <open|block>'
> >=20
> > Thadeu, would this approach work for you?

Javier, thanks for taking a look.

> That's OK for me. Do you want a patch?

Please. Just remove the relevant cases from net/wireless/nl80211.c.

johannes

--=-ElJ/JcpkBWisuxUo7r24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLcRWuAAoJEODzc/N7+QmaYCMQAMLIIxL4/kfiagypOEIwp3QU
/Q8Fc2oAH8bK3ZXYccWKi48cctjfw1GqZqowAC/6hB/sysuP8dmRCUxpjHrMuHem
GIHF3nKK1/ItgL5zDLy/zWnHGJIAvjM4eOPqXrS8Lee2yX4eY2RXzoMMdqyn5CIB
HBgVh+IHWmfVBClsaE5CDeRsCFfbsrirnyzn5pM3Ik9D6VxYzE9BltOi7nQUTAYb
MTqqdmuuWnuBqE4CsbOvAT0QfljXwgXkdx/Sn1gX63UfqIEAkDmfC4YJJ8kj+cyq
bGv0hyM17sqdZzzLBXDaEt64pgJZvtD8YWCHag0HC+DxQe0jnWQSQkFrApP5rbNW
zAm6qcxrIXC7Hp6NxSl/eR9TxTp7VaLZyFttj7aiCloWsDnJvqZqA5fTxLVwkgpy
rJsCdkyCuiPjaJE8fDqIPtUqA1yLXeD65DPVGHniTmd5ZVJOfEi3jyvILeSU5YJ6
CtC9mCKDg5pYtQsmqyEyCVEKjZzaMtnd5zWCBd+P7jHHW5X9aKFMlrgaQdXCOP0V
3zZJHrMIfLoTmPMB5RCkEX99DaXswkZ++m1ZcjN7SptYF1TX69BPUpiMwRG4lGor
rrYMzPKa8RAHRutvX9/bniv3jXMfAOaHSvmaqi+BQy5eX6LoQxz8zReHHXD0E2jq
JYoqngHlrTZfKjHRvbGh
=sXBA
-----END PGP SIGNATURE-----

--=-ElJ/JcpkBWisuxUo7r24--

