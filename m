Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36884 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754AbZFJVHS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 17:07:18 -0400
Subject: Re: [ath9k-devel] [PATCH] mac80211: disassociate when switching
 bands  and not scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>, "j@w1.fi" <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
In-Reply-To: <43e72e890906101404l6a8bee67r560f7c8a1c5f8c36@mail.gmail.com>
References: <1244666131-20031-1-git-send-email-lrodriguez@atheros.com>
	 <1244666973.20900.399.camel@rc-desk>
	 <43e72e890906101349t502e9022h16fa79ea512f8b4d@mail.gmail.com>
	 <1244667817.20900.402.camel@rc-desk>
	 <43e72e890906101404l6a8bee67r560f7c8a1c5f8c36@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ON9JHVZagfEGgw4uZIZ9"
Date: Wed, 10 Jun 2009 23:07:57 +0200
Message-Id: <1244668077.4706.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ON9JHVZagfEGgw4uZIZ9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-10 at 14:04 -0700, Luis R. Rodriguez wrote:
> On Wed, Jun 10, 2009 at 2:03 PM, reinette
> chatre<reinette.chatre@intel.com> wrote:
>=20
> >> > This touches code targeted for removal in recent "mac80211: disconne=
ct
> >> > when user changes channel" patch.
> >>
> >> Heh I don't see that patch yet but if it exists that should fix this
> >> too unless that patch didn't deauth/disassoc. Did you try with it
> >> applied by any chance? I can't seem to find that patch on the list.
> >
> > That patch does seem to have same intention as yours. It is still RFC s=
o
> > I am not sure about its status. I did not test with it, but will do so.
> > The patch can be found at
> > http://marc.info/?l=3Dlinux-wireless&m=3D124458448631186&w=3D2
>=20
> Thanks yes, I see, yup I think that should fix it, we need a fix for
> stable though. Not sure how John or Johannes want to handle this.

*scratches head*
are you advocating those rate cleanups for stable?

johannes

--=-ON9JHVZagfEGgw4uZIZ9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKMCCmAAoJEODzc/N7+QmajI4P/0bwUn3AvzFdUgkTXywo7BhV
A1z07hC1Mzfsk1Puia31aWRBpfmjBaAvEzDP0xAAEODzfsCUezkGVgk7xb0UPeDY
c+mOgUUWxBCVQlWiDtMPNRPNDAiOcAVMn/5pRKsrULy9+jOu8WKnyzukCGkvY6iZ
MB6jCECZvjNpS/ofXOWEpmLpQskE539kmWRsFktkcqVADZ07sa1g2Bq7jFfJwZEM
6sH1wR1YhOl4GqeAhkaUcjWktvlYUIfPhhKP5PnUdkiXOftMFCvug0v4dNm2ldsN
P/71L7DhHNJvenRg+23qRJVMb7Obs1oh77wQhtJej6npRtrK1n7H93NZj80sOThb
SzYzUv0kJawD4pAFZJab8PthMBsqvaByNy9UDS68rYLqX8ddX3CoSIYCLHp0MVn1
saIby+hg4M6oveDHExCmlXIkadfByQs8d0sPqa9LSi7EhqrmzSUwAny7ZAw1psC1
xS5N9uypX5Cr3NuyvlG3q6sDWE3IKHNhepAFW96zdh3apKXuwVJAtMjw7J3fEqxe
O0xTVleYJdYUp5RoxDpUWlv7SXbEW2ljsFvRpjo57nVjAyGshQYXhWa7r3zrslf8
4Sco6dxt1DTHopMX/lEqr8kpFKBHlCib+lqrfNsu6SnDlOnnv9oLSHPDsCYAjj7+
1bTByNUpTDoJTzXgN9YC
=DJsB
-----END PGP SIGNATURE-----

--=-ON9JHVZagfEGgw4uZIZ9--

