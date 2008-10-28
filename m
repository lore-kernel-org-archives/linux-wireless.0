Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56147 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbYJ1Shy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 14:37:54 -0400
Subject: Re: rtl2860 driver in mainline?
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg KH <greg@kroah.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Thorsten Leemhuis <fedora@leemhuis.info>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <20081028170838.GA4818@kroah.com>
References: <20081028004915.GA3442@kroah.com>
	 <4906B944.4010105@leemhuis.info> <1225180598.3796.66.camel@johannes.berg>
	 <43e72e890810280102i3df34e2h9bf281c5d1e00a48@mail.gmail.com>
	 <1225181562.3796.76.camel@johannes.berg>  <20081028170838.GA4818@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NxZIzt7K6PurtfR/Nnc3"
Date: Tue, 28 Oct 2008 19:35:52 +0100
Message-Id: <1225218952.3598.39.camel@johannes.berg> (sfid-20081028_193756_382628_82C22D1C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NxZIzt7K6PurtfR/Nnc3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-28 at 10:08 -0700, Greg KH wrote:

> "Work on", or "USE".
>=20
> The problem is, users have this hardware, and they want to run Linux on
> it.  Many distros already support this hardware with the "crap" driver,
> so we might as well add that to the kernel tree so they at least get the
> latest "crap" so that users have an easier time of it.
>=20
> Now, the fact that there is a competing driver being developed outside
> of the tree does make this a bit more complicated.  However, as it
> doesn't work yet, there's not much we can do about including it, right?
>=20
> So adding the driver to the "crap" tree makes users happy in that they
> can use their hardware.  I'll support the "crap" to a point, and no one
> has to do any API changes to the drivers/staging/ tree either, I can
> easily handle that.
>=20
> Then, when the "correct" driver is finished, I will drop the crap driver
> at the same time the "correct" one is added to the tree.
>=20
> This way, everyone wins, right?

Only if the point is "use" rather than "work on". As far as I understood
about staging, the point was more "work on" which would direct effort to
the wrong driver.

johannes

--=-NxZIzt7K6PurtfR/Nnc3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJB1uFAAoJEKVg1VMiehFYt78QAJ+Wc9OldgUJOT83sFiYXhyE
PPKOEfn05mLbmeGvzAdwu4/dArtCLAXpWKHhAvPIaCSvY4mXWs18RFG2omytB8Oh
fbvWKIHlm/59hQoo/GBxuv5ptxV21dJ1/Jat77JNvME6jiDoVDysv6bptq1xJtSb
amtgNsHYSzO1ESEoZhK9v6jtDuQVSKScNIFPPLRYxf2ZA+3wSX1+P4K6XDvMCYVz
z2OLxIhMMbw/yLvfr8RvfylG++ZAfMyXcFLR07feFmtRBEbjXvmA2iDeSwfcicMa
/o2DkX/EiElWJk/eiktNaWdDOiu2WBHtuNXqwgpAvvvRARdh6TIzlii7BHkNF7Le
JoK/+rcCPFRDIe5v42P09oBzIzlf9Q1mm+xuOq7Ttl/pvZkMRLGwovcnKn1Q5B9K
w5NhM/K3e5yXpe0cmkgbOO6FxbPMBft/R+FCF8vbu96eMEll/s3/0asnR416G6Sq
rKeOKt1rsOOvl1ahfjR6ndUUg5ljqqcnPqzn470xKNRsfQUvfY7WpcbzMTEuHSn1
EV1roG/aHzBsmOvBizlNcxWHYPrqlyyqovJOCtvPogr4Syge9rBSQi/MT8RODHO8
Rnz3qzKeFUs6Iu9JzBOO+rdE0afSFiWCXv3RuErpHLV4hdegJoToTSpBZHBqihOA
7qCm5If31SHyqubSlvs1
=JRwt
-----END PGP SIGNATURE-----

--=-NxZIzt7K6PurtfR/Nnc3--

