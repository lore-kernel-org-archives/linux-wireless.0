Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44673 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbZCZILj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 04:11:39 -0400
Subject: Re: wireless powersaving (in NM?)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>,
	Matthew Garrett <mjg@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>, Jouni Malinen <j@w1.fi>
In-Reply-To: <43e72e890903260100w75896d0fi9121f227cc7ca8dc@mail.gmail.com> (sfid-20090326_090603_527463_A3630685)
References: <1237891149.4320.73.camel@johannes.local>
	 <1237910398.9082.7.camel@localhost.localdomain>
	 <1237979070.4320.156.camel@johannes.local>
	 <1237995072.18896.9.camel@localhost.localdomain>
	 <1237996137.4320.161.camel@johannes.local>
	 <43e72e890903260100w75896d0fi9121f227cc7ca8dc@mail.gmail.com>
	 (sfid-20090326_090603_527463_A3630685)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-RkK1WTad94jK2mtl7t/O"
Date: Thu, 26 Mar 2009 09:11:00 +0100
Message-Id: <1238055060.4331.1.camel@johannes.local> (sfid-20090326_091143_315952_8D3CF004)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RkK1WTad94jK2mtl7t/O
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-03-26 at 01:00 -0700, Luis R. Rodriguez wrote:

> > Right. If a particular chipset doesn't properly supported PS then we
> > shouldn't actually support it at all -- but we cannot know if the AP is
> > broken.
>=20
> How about leaving it to the supplicant to guess if the AP is borked or no=
t.
>=20
> Kalle, what would happen with these broken APs?

We talked about that briefly yesterday -- it's not very easy to
determine this because of the various ways things break:

 * one AP sets the broadcast/multicast bit one beacon too late (after
   having already sent the frames)
 * one AP doesn't buffer frames at all
 * one AP doesn't respond to PS-poll frames

etc.

johannes

--=-RkK1WTad94jK2mtl7t/O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJyziRAAoJEKVg1VMiehFYMyAQAIZPj71u9uF4ifpEK8si7Ffz
yVwNObjr/L5vfRG1w4VD6bGjzh3spQ5GttPUfhasvE4tG5JcuD0eQsyAGTdWzani
5Ajxw+I0HyUdRFJr9D2tRl6oAOEwxUPqresqD+p6yzDbTTRWPwBA1I8PSgyz02yh
dlaDDrJ+lpbFpuwWOQNqZ07QwBt+E3KFS2HAxhMW+vJ7r+lwAQKw6ye5CLX2bDPW
blXOQo0hjSQZ0bLbdju6axx19g/7ijf2hgAzOKEy0T6hNnXvGVU2YaevErYfkAum
NO5SzQddAdT+Z3aXTA+FAFk5PYfrdx1kZ4ziB56zCGvUya6kl9iHccqas6T5xIW4
UQ4Qko1JwyB1X0QtAuClPhDsZElxvxjbTKZ55un17osLfTnobVtqPcBdfi16TjaK
i2cAyH8s8scUVowaMd7f0aiX9WbtKnwk9O1Xa9+96XCLW+SPt+3jjI8I8hpmAQXD
zquSrOaZG3f6lZGfZzoYLpEmMSNBFhejoT9vI0zHWohk7NJ/fzlDbWcIWWo+fUtG
7SjALJKDqHm6023Dx0rbozeXn2XXCO0v3q9+B6i6Yoc00TRejh7CAugRoSOs6U1g
e4vm/wUCy61bQ9qAChY/HG/STsbMUuqs4g6qaR3CU2PT+EQgfFJIK8adCrPF6FZj
akISYDBlZCpMk0lONLjJ
=xfYL
-----END PGP SIGNATURE-----

--=-RkK1WTad94jK2mtl7t/O--

