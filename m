Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42322 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002Ab2FSJRW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 05:17:22 -0400
Date: Tue, 19 Jun 2012 10:17:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wei Ni <wni@nvidia.com>
Cc: 'Philip Rakity' <prakity@marvell.com>,
	'Stephen Warren' <swarren@wwwdotorg.org>,
	Rakesh Kumar <krakesh@nvidia.com>,
	"'frankyl@broadcom.com'" <frankyl@broadcom.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Mursalin Akon <makon@nvidia.com>,
	"'linux-mmc@vger.kernel.org'" <linux-mmc@vger.kernel.org>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	"'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Where to power on the wifi device before loading the driver.
Message-ID: <20120619091719.GZ3974@opensource.wolfsonmicro.com> (sfid-20120619_111726_145626_C9069FB8)
References: <6B4D417B830BC44B8026029FD256F7F1C377BFFE88@HKMAIL01.nvidia.com>
 <4FD90352.9090606@wwwdotorg.org>
 <20120614063120.GA20167@avionic-0098.mockup.avionic-design.de>
 <20120614121234.GC3913@opensource.wolfsonmicro.com>
 <4FDA092E.10301@wwwdotorg.org>
 <6B4D417B830BC44B8026029FD256F7F1C377BFFE8D@HKMAIL01.nvidia.com>
 <4FDB5976.20809@wwwdotorg.org>
 <6B4D417B830BC44B8026029FD256F7F1C6EE2DD61F@HKMAIL01.nvidia.com>
 <43E4817426ED174AA81263BCECB4351D138E8ACD6B@sc-vexch3.marvell.com>
 <6B4D417B830BC44B8026029FD256F7F1C6EE2DD622@HKMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6ysXqiu0yoUmUNJB"
In-Reply-To: <6B4D417B830BC44B8026029FD256F7F1C6EE2DD622@HKMAIL01.nvidia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--6ysXqiu0yoUmUNJB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 19, 2012 at 12:25:58PM +0800, Wei Ni wrote:

As Stephen previously said please fix your mail formatting - word
wrapping within paragraphs is important!

> On Tue, Jun 19, 2012 at 09:23:35, Philip Rakity wrote:
> >Why can't you use the regulator notify to get called back on power or=20
> >voltage change options to plumb in the manipulation of the gpio. I can=
=20
> >imagine you might need to add a notify call in core.c if you need to=20
> >assert the gpio before power is applied
>=20
> Yes, we can use the regulator notify, but the Tegra30 support is via
> device tree, I think there have no special board file to run the call
> back.

You can mix board files with device tree for cases where device tree is
not yet up to the job, though the goal should be to come up with a way
of expressing things in device tree.

--6ysXqiu0yoUmUNJB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4ENIAAoJEBus8iNuMP3dV3AQAJZ5EfiY0JeT/Y42cpJBJwGG
qzabJ1J3K7ky0rIFa+F/vrDJcISCtADNqyd+Qs2igokZjAz5BsTdSqMUa+tS2APn
DxWpYg0vxmmXp6QfJcVaqzQlDqawZ7ZwEKV4nwq0Ux6IvHLnkuHZMPKJs90GiXiV
IVjCbe/m1stYARcxvkbc23Y5RVQR6PJ9tubdyXxW+F1qV99ofTALWuXH29e8h8fg
/aRLNAKzktoyxxnNaNSlqxXINPggkIzr/BLVIdAwGCdF0oiDgg44wN8EQvY0DZtX
P5xvdeC12UG0SsBli1zft/buuOWdzYas+pdC4C7v84+baiQs1MxtAbefixaIZLH3
kH59UtwFSxLuXvF/MJZPrZw2/8wYh1eleBp86Ye0Ipzn//mImhUZ8/4h0xGU95lr
BB1OQG9HfUZoftnsES8Ri6+fAIEBdmn2dStwuiBO/n7hqdEh1r+NNhN5do1x8VJ/
nLfqNyE9uOVBVHI+0BE1G5+veO/agc+XYZNY+rCP7PZYgBpnMoz2bJFUU7WP16MQ
b9CFxjPXfY9hlBv3mrg82oXQLnAaSaTjyzrA5/hW9kRJgl4S1g4ZE8efLA3BVqnS
PClOE7VrMiynW/RUK+w1SfsLKDaJipTXGE/FvKQzAduhlbmzMHimpKEvg7z3BFwD
VZUTtD1P0zK1YZqadjDl
=D/TS
-----END PGP SIGNATURE-----

--6ysXqiu0yoUmUNJB--
