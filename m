Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39422 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759944AbZEMOi7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 10:38:59 -0400
Subject: Re: [RFT v9] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <9b2b86520905130736j6cde99cak6fad414531b0168c@mail.gmail.com>
References: <1242030669.6930.10.camel@johannes.local>
	 <9b2b86520905120709v4bd00e1eo4da26e6c5f75c4ba@mail.gmail.com>
	 <1242211796.29288.7.camel@johannes.local>
	 <9b2b86520905130736j6cde99cak6fad414531b0168c@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tW+q113J5ex3qtBwKjVH"
Date: Wed, 13 May 2009 16:38:27 +0200
Message-Id: <1242225507.9913.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tW+q113J5ex3qtBwKjVH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-13 at 15:36 +0100, Alan Jenkins wrote:

> >> <http://picasaweb.google.com/sourcejedi.lkml/Screenshots#5334936857267=
342674>
> >>
> >> The kernel then hangs later on in the boot process.  It responds to
> >> SysRq, but does not echo normal keypresses.  SysRq+P shows that the
> >> kernel is in the idle task.  I left it for three minutes, but I didn't
> >> get any trace from the hung task detector or soft lockup detector.
> >>
> >> At first I thought it must be a problem with wireless-testing.
> >> However, it went away when I eventually tried un-applying the rfkill
> >> rewrite patch.
> >
> > Confusing, but I think the stacktrace is just bogus. Can you recompile
> > your kernel with CONFIG_FRAME_POINTER please?
>=20
> Nope, cos it's already enabled :-).

Damn, I had hoped to get relevant information. I really don't see how
rfkill could cause a problem in regulatory code, let's ask Luis.

johannes

--=-tW+q113J5ex3qtBwKjVH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCttgAAoJEODzc/N7+QmaWnYQAKfMjd0ribTMX2o/8a49+Cfq
0LVRDgaFOhGJEyBhVpdBOmkree7NzYNbfis1PioY7lhrwDMq9OCj6uxHTkqLFtt6
cct2+ymTSVDgu1B1u1x//MAPtGe2q7RZcFqh2DZGbKk3pNQ1O0H2f5AewSxl0ZIE
f1blvgriQBBbXyoD9HJVl+UFeminI+ra0ixFNrMF16Kt+8fh6aHlDDpzLyu3ZhCy
IkihN7P2FvSUHpNYCAR26X/70LyGz0jRnwcUaIGrX+2ubVQZPr1NOe3ueLscQvbM
IM5vtBa5pF5KQ/4kluQDnSl7KbKPwV2SCnmFy/B7DZVxLeLPd+bnnLiklAB4LprA
cTsyMnaYu1MrMlHrnmvVmPeEUK3kAJmN6EcXSzpNXpc5UtODgfZ7uAlOAgP1+JnG
josKoFHEozKILy3rx/veU/1KK2RaVF/XLZuskx5DaiY19Co+aPVev+SXMH0gzsPc
7ZK2mjG9xogl7N2zsMsGmWTAFyQ/xT288bpFVp5smPcvMQ2evg3si7ri7t1giJaf
xJNlzcnA04G6h1ZzwSt5ejbhM39UfWrszguvq3iFp/GSPrA27/C0ltl5QtdF48TN
vCbqaNGUGEfmxWo0X2MQz/1z1YZofyk/AzV5NizMu6W5khyWdJOsFtKFogZH/7KY
wDMBqYPRfixcrs1/XBqK
=HvHz
-----END PGP SIGNATURE-----

--=-tW+q113J5ex3qtBwKjVH--

