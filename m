Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58057 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbYFSGuW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 02:50:22 -0400
Subject: Re: BUG: mac80211: Some connections hanging in 2.6.26-rc6...
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Price <andy@andrewprice.me.uk>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <g3cc6h$q5d$1@ger.gmane.org> (sfid-20080619_031958_028400_7BC16156)
References: <g38o2j$1uh$1@ger.gmane.org>
	 (sfid-20080617_181742_447297_198DA5E5) <1213773749.3803.155.camel@johannes.berg>
	 <g3b7l1$t1o$1@ger.gmane.org>
	 (sfid-20080618_165548_538551_7C9BA1D8) <1213803761.1312.29.camel@johannes.berg>
	 <g3cc6h$q5d$1@ger.gmane.org> (sfid-20080619_031958_028400_7BC16156)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-H5sr65af65vUS/MrMBdw"
Date: Thu, 19 Jun 2008 08:49:46 +0200
Message-Id: <1213858186.1312.43.camel@johannes.berg> (sfid-20080619_085024_786915_8B8CBC1B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-H5sr65af65vUS/MrMBdw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-06-19 at 02:19 +0100, Andrew Price wrote:
> On 18/06/08 16:42, Johannes Berg wrote:
> > Hence, that commit is now reverted, see
> > http://git.kernel.org/?p=3Dlinux/kernel/git/davem/net-2.6.git;a=3Dcommi=
t;h=3D3a5be7d4b079f3a9ce1e8ce4a93ba15ae6d00111
>=20
> I've updated my kernel to Linus' latest since he merged Dave's revert
> and I'm pleased to say the bug is now gone. Thanks for your help (and
> thanks to Dave too).

Well, thanks for spending the time to bisect, the bug had been reported
a number of times but we never knew what was up until that tipped off
Dave. :)

johannes

--=-H5sr65af65vUS/MrMBdw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWgGGAAoJEKVg1VMiehFYd3kP/iVOF+8guyit05GYvs2naYie
1F20T/c8hJI8B/EPVtsFgXU2tIRkILEDbKHdZB6ifFYuVYj+7Tv77EswnLmWNc29
GtTIpekJ6/B+VeNLZAJ7qKnYvSmr/Dnh4bHfBaku+tRqV0OdavM7QUke7qT1wfX2
vZskPh1XF6wJNA6goKo0Wa+FJHksef0LNw3k9J39IiJo7GB1hXHXRkP0KwWAU89U
SRE9DMCoNZ41/jqNgoe1LJBOrxE1z7ODCXcmm6w0em9UuZU+PTadeW02uxReAmrm
Fij69hkbuIXkJnS5Nx+jzKvkE+JwWWx9/KB6/+hVagSaVouUF6gdKKDTu5CJsweD
ztyqFLGR39jMuTg8MLQQmDpzruTJ2Vpt9yQvDtGCYJremLx0h9mG64wArC0fXRZV
kmkK0jrLkpF7VsuW0Oit5QxZOq0+vszjU2eGDarEPwRrJ+0UZAvG6u87t9wR/KER
qM2cIb2G8ZaSrHrTddna1ze1FqeNEeFsznYXSH2E11XhRK9Nw70WCDBvXJ+FDCi/
fDtDPkH//knWyUhAYKj4DmTapx2Yfj3OXSeUcYsYgQTsdPFnwprb1ZMlB7RTAyN7
35/R5pXOOlo8xMdkn7AbjCV6EUamW91tqWa6T9l62ACQ9yyTCcSTuUgn6DRHR6ke
onLQv+/ECqzVIqFBCg48
=gmut
-----END PGP SIGNATURE-----

--=-H5sr65af65vUS/MrMBdw--

