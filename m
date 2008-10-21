Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38272 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbYJUGnb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 02:43:31 -0400
Subject: Re: New Regulatory Domain Api.
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Zhu Yi <yi.zhu@intel.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224569252.9386.77.camel@californication>
References: <20081015112517.GF6509@tesla>
	 <1224485431.18024.12.camel@johannes.berg>
	 <43e72e890810192359g2bc75316v49377ddc9eded934@mail.gmail.com>
	 <1224487340.24677.192.camel@debian.sh.intel.com>
	 <1224520999.9386.72.camel@californication>
	 <1224552899.24677.245.camel@debian.sh.intel.com>
	 <43e72e890810201842o44db616ekd8d5bc66cd1006f@mail.gmail.com>
	 <1224554323.24677.248.camel@debian.sh.intel.com>
	 <43e72e890810201937l3be24156t2172590138fda132@mail.gmail.com>
	 <1224561748.24677.274.camel@debian.sh.intel.com>
	 <43e72e890810202158m197b52a8y98844fdc9e1ccfd8@mail.gmail.com>
	 <1224569252.9386.77.camel@californication>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7B+jjIQK45NrjHIjntlL"
Date: Tue, 21 Oct 2008 08:40:29 +0200
Message-Id: <1224571229.27899.63.camel@johannes.berg> (sfid-20081021_084335_939586_F3798BB8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7B+jjIQK45NrjHIjntlL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-21 at 08:07 +0200, Marcel Holtmann wrote:
>=20
> how does an old userspace with a new kernel works? If we essentially
> disable hardware by not having the userspace in place, then that is not
> a solution. We have to be able to install a new or development kernel on
> an old distro without having to install crda/iw or updating udev or
> whatever.

I'm not sure where you're coming from. We can always keep the built-in
option for EMBEDDED, but currently if you enable the "old static
regdoms" option there's no regression at all vs. current kernels.

johannes

--=-7B+jjIQK45NrjHIjntlL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/XlXAAoJEKVg1VMiehFY99EP/23oXiQvsWe+2j0MR7t6sFKa
9Q81NFyResqvG0gk/KA8QL4r3tq3pHLTkFKKrLk2OkN+cGYXS2SSRhb5/dp9d138
MvApUzFbtyXFjfTOyKprLiL2wB1eJvG6pFlC3gstNsoP8hevTESEajK4ktmko5h9
cp90TrviFI3sUZhmsRSM8oDytUJ7GQSM0SSMnRoGs1wPEqugh4gtSiTaDOy2HvFq
hbCU8YyE5g3FD6MueCVQJh3r4KLARNw4buWd66g3oRNtZ4gKapkvqrmG1G06/tCM
16mFNUH3Iwz2Vit1dUjJAtS8Bu7fWMV55h/prODsJcUMpd1zrLCssAbj9YVghjuo
wk87eVmqaZLtUPWoSeAIdegSk1beKuBAhLb0uwS0Ftigpkd2fEgrP+zTbeVTHXBq
jobspwLGrANbauU2LBnpDnROJ0ln9GLx6lEWOTINB2QcZApdgPLBz+s5c9js4WGx
v72K4hgzcqSFXzcunSi/v0uPGbZ5RHmAGjVd5GE1OGapNN0CZETpsjcoEzuR/zCg
MNtRX8kYwbylke2ORi/yKdmHIb5Nk+LiEqksFzPtvI0OVY8mjl5+EDQjjv5L5yzk
eBVDZDouFitk04awvMMonl2Uh8X1xzsqr/U+1W+vSv4CnDzJOKJ2u2LY3JEGq9dz
in/5/l4hatg+LZh1KqAH
=8KpU
-----END PGP SIGNATURE-----

--=-7B+jjIQK45NrjHIjntlL--

