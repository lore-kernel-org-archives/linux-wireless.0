Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57067 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761586AbYEPOvR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 10:51:17 -0400
Subject: Re: [PATCH stable] libertas: Extend CMD_MESH_CONFIG to get and set
	persistent mesh default params.
From: Johannes Berg <johannes@sipsolutions.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Brian Cavagnolo <brian@cozybit.com>, devel@laptop.org,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Andres Salomon <dilinger@queued.net>,
	Javier Cardona <javier@cozybit.com>,
	Ricardo Carrano <carrano@ricardocarrano.com>
In-Reply-To: <1210946949.3008.16.camel@pmac.infradead.org> (sfid-20080516_160924_625301_06CD189B)
References: <482c8eb8.0b97600a.08e2.ffff8ee3@mx.google.com>
	 <1210946949.3008.16.camel@pmac.infradead.org>
	 (sfid-20080516_160924_625301_06CD189B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-y0LMuYJQ4gGYZtvs9N5P"
Date: Fri, 16 May 2008 16:50:48 +0200
Message-Id: <1210949448.6381.13.camel@johannes.berg> (sfid-20080516_165138_959673_C980C0F6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-y0LMuYJQ4gGYZtvs9N5P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-05-16 at 15:09 +0100, David Woodhouse wrote:
> On Thu, 2008-05-15 at 11:01 -0700, Brian Cavagnolo wrote:
> > This patch is based on a patch from Shailendra Govardhan.  It introduce=
s
> > several new iwprivs: {get,set}_bootflag {get,set}_boottime {get,set}_de=
f_chan
> > {get,set}_def_protid {get,set}_def_metid {get,set}_def_meshcap
> > {get,set}_def_meshid.  These commands are only supported on Marvell har=
dware
> > that implements persistent defaults, such as the OLPC Active Antenna.
> > Accordingly, this patch may not be suitable for upstream merging.

> But this is the _one_ thing which might actually be OK to do with a
> private ioctl, since it's very hardware-specific. Unlike like all the
> mesh-mangling stuff where we really ought to be compatible with o11s.
>=20
> So maybe, just maybe, we _can_ do this with iwpriv and push that
> upstream.

Maybe we do, after all, need an iwpriv equivalent in cfg80211/nl80211 so
that we can kill wext at some point.

Or maybe this should be in sysfs or so?

johannes

--=-y0LMuYJQ4gGYZtvs9N5P
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASC2fR6Vg1VMiehFYAQIgYBAApBnpMoRHHTtqJQ4vCWJK2lPeQSwLYrQE
ccbp5yPZmrnlYcHGoS9+vh1cj4yiN8Ey1SjLog4Kum9GU4fgLOPYgzjiPbqve+es
U+XxoazMisYUNiVFuTV29gfYuC3Xgi5VbDiadcP47wcXl0PHEfpTKBKMKNgMA8Es
5WmKDjcySuz9Hs0i76ReuWitHqntYzABpSxOrUMpeGLSHdI1wJ7ZG8BtA4GDYNUI
EUZgSh7SjYn1HXxEmDbNl20xXBS0gfXGmJFhapLCkpuXVWQOzsnoidbQ/m0KpsG/
oolJVRSxPj0xncLu6G0g46m/eTQQ7NLG5zjDgJenbG7mf+LrgMiza8aiDH69obgM
xiabI/ByIhInvl6szTlJZmeHpgGl3WHu9Idl7NY4MwAhAqjCU6QdttyKyhXJJOCR
Hou4/7YoZRh6ZfFbL9D4CfepePdX4sSvGLu4/uuCosR6aj5DeSaz45Vx2a9QhCoy
BxLc3wg1U0+6ioh/15p+G7p5psQcvXW9U2YgjSbAxSmCMZC0WYyDHiW224xXPA8t
EoewDaA/o7UHQJtJn3BRABiCtVrv+jKeQ9lndgLu1AG0HyTMDdJBTEhhfYRVfhzy
Im0x9GVAAJZPjy1cTAtJrub2V+VjDnNl53UQaQNQ7cxASfAhxZkOp0FLlPsju66P
KjQ7fUf8epw=
=udzZ
-----END PGP SIGNATURE-----

--=-y0LMuYJQ4gGYZtvs9N5P--

