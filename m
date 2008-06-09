Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45159 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536AbYFII7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 04:59:43 -0400
Subject: Re: Backported MQ requirement on 802.11n for older kernels
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	compat-masters@lists.madwifi.org, tomas.winkler@intel.com,
	Tim Gardner <tim.gardner@canonical.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <c85cb4470806090053l5b763a23j43bbf0c87f594b0d@mail.gmail.com> (sfid-20080609_095323_587268_F99F90E1)
References: <43e72e890806080855p284f85brd0ff1f1dfce96bf8@mail.gmail.com>
	 <c85cb4470806090053l5b763a23j43bbf0c87f594b0d@mail.gmail.com>
	 (sfid-20080609_095323_587268_F99F90E1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/sEoTPKoMBnvhp6pNXQD"
Date: Mon, 09 Jun 2008 10:56:37 +0200
Message-Id: <1213001797.698.57.camel@johannes.berg> (sfid-20080609_105945_500810_D2151480)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/sEoTPKoMBnvhp6pNXQD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-06-09 at 10:53 +0300, Ron Rindjunsky wrote:
> >
> > I just finished trying to backport CONFIG_NETDEVICES_MULTIQUEUE
> > requirement for 802.11n to older kernels by relying on the old
> > internal mac80211 hacked up MQ support. I've tested the build on
> > 2.6.22, 2.6.23, and 2.6.24. Let me know if you get to test this,
> > particularly iwl4965 using 11n on 2.6.22.
> >
>=20
> in config.mk you put MAC80211_QOS=3Dm, and i guess that the intention was=
 to put
> CONFIG_MAC80211_QOS=3Dm
> if this is the case then the compilation fails

It should be "y"

johannes

--=-/sEoTPKoMBnvhp6pNXQD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJITPBBAAoJEKVg1VMiehFY1HcP/in1xrIJuI3e/H8DqKxoRSmN
lrEU3kwMqphcJvUtCUCVX2SLuTKZAlyQryQAwZ5d+9oefAi088PMocB1fLHxAwkj
25BK9kWSFwj2Zx99dwZ/+6230kdgavTH3f7qXXWr2rijnOA/PH7piGNZ5vMCzz04
19M40/DAtrb8Rf2dkzIWPXAaQz0xGCsj2SVMUE9g0RkTSxdCfRwX45W76SanPEm4
PA1vfaHQKNCzMZ10d7B3iRkGkQwZ4auzCUl3el/hSivn/0WQ5hZYNvtRJI1N55PO
eM5dMxbKDsQCP9bkQ+A4iBSTHAdaY+U06G2fRVv/nRE8JF+JbcQvOPDIx4mjdNSB
beSsMybYPp9WZi6ztg8Nr78HdFKGyg9d7WAsKfeR6heaeu4C7xBhnINawe5iQoTq
Z1n5ITW5Xanbsqkp6Tc72ifiKAgQrRlRCAvKXHw75/S67UVGf/wNP/5BDhOei1TH
CZyNT4cC1MDMQmn5t4YXJtQ7gfjiHY+jqUywCZI5MMAvE/VcEtbdiQv6kx+ncc5A
QPdJFpz3nzUe0oe2qaJcxv6RIRt8pXBnbWHyw+7sLUa82yrjEnQG5qbgXpGMVOn9
URP3N3ADJp0c1x/Tgfx6GaYk1KjXdZg2W5tiNvYLyTQPyvBVFNfm08t1pHnQV4ev
ZLzIuVtwvmI3ByXxqZBo
=b5rS
-----END PGP SIGNATURE-----

--=-/sEoTPKoMBnvhp6pNXQD--

