Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54345 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761206AbYFZSVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 14:21:37 -0400
Subject: Re: [Q] ath5k : doesn't support AP mode?
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>, cs010101@gmail.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <69e28c910806261109i28fe2c29t5218f32f5e65c378@mail.gmail.com> (sfid-20080626_200949_652046_F81D366C)
References: <002901c8d737$e51bb2f0$3b0aa8c0@39fb6b6b6f434b3>
	 <1214449044.18897.15.camel@dv> <1214487200.20763.44.camel@johannes.berg>
	 <1214492236.30044.7.camel@dv>
	 <69e28c910806260846s3b02cdddlca3ac138acadd8bd@mail.gmail.com>
	 <1214496086.30722.14.camel@dv> <1214501242.3783.7.camel@johannes.berg>
	 <69e28c910806261109i28fe2c29t5218f32f5e65c378@mail.gmail.com>
	 (sfid-20080626_200949_652046_F81D366C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wh/lvGhFAkrPParIxszY"
Date: Thu, 26 Jun 2008 20:20:54 +0200
Message-Id: <1214504454.3783.18.camel@johannes.berg> (sfid-20080626_202204_838545_609D9FF1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wh/lvGhFAkrPParIxszY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Oh and I never answered to this. I disagree. Requiring people to patch
> > their kernel for AP mode support is a good way to discourage
> > "contributors" who don't even know how to compile a kernel, trust me,
> > I've seen a fair share of private mails from those (which I ignore: do
> > not mail me in private about AP support).
> >
> > Hence, I don't want to do it for exactly this reason: a bunch of dumb
> > users will enable it either way, and actually _working_ on AP mode
> > _will_ require kernel patches, so this isn't one that matters.
>=20
> The problem is that the location of the patch is extremely
> non-obvious.

Umm. The paragraph you're quoting:

> "AP support requires mac80211 and nl80211 enhancements. In addition
> to this you need external wireless-test.git patches from johill and
> hostapd patches" (from the TODO-list) suggests that more than just the
> "Allow AP/VLAN modes" patch is required to get any AP support

actually links to the patch so what is your point?

> Also, someone who can't patch a kernel likely also won't be able to
> compile and use a git build of hostapd. IMO this provides enough
> foolproofing. If we need more, then maybe add a secret and
> undocumented (but clearly deducible from the code, not obfuscated)
> parameter to hostapd, without which it refuses to handle nl80211-based
> interfaces. The location of the patch can in no way be deduced from
> the code.
>=20
> And, by the way, should we also require a patch for all experimental
> drivers? I don't think so.

You're missing the point.

We do NOT want people to use mac80211's AP support UNLESS they also work
on improving it.

The "improving it" part REQUIRES patching the kernel. Hence, requiring
patching the kernel to get AP mode support in the first place cannot be
considered a hindrance.

johannes

--=-wh/lvGhFAkrPParIxszY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIY94CAAoJEKVg1VMiehFY2M4P/3opKaCKe7LCJ5HAHtt7Hf+V
vkR3f/WFhfEZLNBCL6ORKnnKruFZ6lPKseuCBLC4UifDj63Pbb/C4Bo2wF0XihQf
7FAp9SSQ5w/5miJjwICe6lR1qE//cADtkGWjZQoKUZfsNDvNiFR9lh55wb6pI7SU
fQzZKfX8K+Y23ZSH7oEwEgBB3c3waPd6qaB47PDlMo6QTaHwhK4UnZpwtCSe8sOE
Oo8EjCNz9F1WmaX7WR2KgdDG+Q/Jadk9eHqOpLLztxWhw6Loi3G8MPcCEb8hM3QZ
l35hxcdEz/etgj7VsC+0KfTxIOHUdmckvIhkLdhKMcZtgDp3FPFfYkuGLlXwB9Cy
LhW3wyEo4mrf3ZYO/XatVwSP/pNlcqRN18f4rYlLvslz9WxobEqVTgU+0FKJzu6V
bg40VSlGtx72D+cfH7K5+GjmWnGzMEbfpVHokcexCpaoFnEQ0VWzAtlHmw6Q02Z7
cPMV3zTlHwnIeof3VAnu857EmdBVnm1RoAMwyUVZsxuBJhkRHSA3cypYw7pLG0qz
i1SBCo9CMZuaMnikwLbfLH+UkguuV6wBydwoxtkLWsSgYKhAoaYt10pahDHorm91
W1u5XDx6FxuosTUWpxxqkzHGsmtXFUUC+grV3N+XMyYd6jE5PqzHJjdAa21pYU65
Ybx5lorW/gJH/5Bv7gGP
=Bow+
-----END PGP SIGNATURE-----

--=-wh/lvGhFAkrPParIxszY--

