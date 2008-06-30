Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44756 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429AbYF3LF7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 07:05:59 -0400
Subject: Re: [PATCH 1/1 V2] cfg80211: adding NONE regdomain
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Tomas Winkler <tomasw@gmail.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	Ester Kummer <ester.kummer@intel.com>
In-Reply-To: <43e72e890806300159j6c98ef9dpeac61d5aeca19f0e@mail.gmail.com> (sfid-20080630_105921_107951_7309D2A4)
References: <1214732604-4573-1-git-send-email-tomas.winkler@intel.com>
	 <43e72e890806300118me4b20bv2b91f30f91eaa7f3@mail.gmail.com>
	 <1ba2fa240806300152o6d5f7deby6d00a4421138177c@mail.gmail.com>
	 <43e72e890806300159j6c98ef9dpeac61d5aeca19f0e@mail.gmail.com>
	 (sfid-20080630_105921_107951_7309D2A4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1Y2wmMbEMKL5qxyTs8El"
Date: Mon, 30 Jun 2008 11:22:10 +0200
Message-Id: <1214817730.5507.27.camel@johannes.berg> (sfid-20080630_130607_372528_3B677121)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1Y2wmMbEMKL5qxyTs8El
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-06-30 at 01:59 -0700, Luis R. Rodriguez wrote:

> >>> This patch adds an option to enable all the channels by adding a
> >>> value of "NONE" to ieee80211_regdom module param. This is useful
> >>> for NICs that rely on EEPROM regulatory enforcement and for testing

> > Still can be useful for testing,
>=20
> Testing can be done separately but not merged. The idea is to keep
> mac80211 and mac80211 drivers as compliant as possible. This steers in
> the other direction.

I agree, testing is no reason to merge a patch if it's intrusive and not
useful outside testing.

johannes

--=-1Y2wmMbEMKL5qxyTs8El
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIaKW/AAoJEKVg1VMiehFYv0kQAMXkPAmDvjin0v0l0JE1wiWo
2ytmJRcVY/BQePQQ6u9E/82XqtPlSW5hZ18/L4g71CFbrtYVgFUwBHNvSnmREgr2
b/TtS/75UsXcMdc8hsdGWPb3klYBrfKhWYE7rcZAnDz7MbF6jGV2+fL4jJ1RZ1d1
TV9GsQNp/Wdn8SW6hXcoMYqMHn4bz7ifpqbW/CUYyNBUOJrYzXrt+EniljY21P3x
evqjBoNuj6cYI79q0RMyl0pwR5Mhv8opWFY8O2p8TAiHQdoMmqLGoa09gX9+eyTD
rB3Dru2fhZ5ULYyTDacwxaHjGy7nmIIrsKhKokqzQVrnFtR6W0vV24Ftb/nBqqe2
2aUrgwauFHzdJ4Ycjc0zhEzLz+egOlGNM6RoA81iYPh0M/fksewptFLQjyd8hui5
FAAWaPM9PgpVlxV3k45NTmVtt80YmIxXXMINrygyhSIPIB1MhVkFYXXIlDK+WcJk
UYjoA0e+7g8zsAD+yLtiqM7duKOunPwEdT4bhdjl8Pv+2mMokMPbddb+vQnggrEX
LPEhBggrv1HAEBJ+eb0zjYidhqqsWYnPjdbsFwdv+roibotsC0y1ZqgQEZ+mqkiB
27dS9HppMaCV2ZwZbyocjPF60Ipr/7VElCR2Wj4ldRx/l4feG+ecuazTrac4ZDf8
d1+H3VD9wreUHcvqm0ue
=fzqq
-----END PGP SIGNATURE-----

--=-1Y2wmMbEMKL5qxyTs8El--

