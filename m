Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37245 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbXLKOwg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2007 09:52:36 -0500
Subject: Re: [RFC/T][PATCH 1/3] rc80211-pid: introduce rate behaviour
	learning algorithm
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1197319867.7493.4.camel@localhost> (sfid-20071210_205142_109612_504EEC93)
References: <20071209211547.2d7fca32@morte> <20071209211931.26ff42fa@morte>
	 <1197239150.7543.13.camel@localhost>  <20071210090853.79ea4645@morte>
	 <1197319867.7493.4.camel@localhost> (sfid-20071210_205142_109612_504EEC93)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rcBXHSTtwh1FmfOL/otz"
Date: Tue, 11 Dec 2007 15:52:34 +0100
Message-Id: <1197384754.4037.23.camel@johannes.berg> (sfid-20071211_145239_477230_132E50A1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rcBXHSTtwh1FmfOL/otz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > 2) that can be changed in userspace, but we couldn't figure out a scena=
rio
> > where it would make any sense. Johannes, any comments? Wouldn't it make
> > sense to just forbid to change this in userspace?
>=20
> I don't agree. For example, what if you have some broken 802.11b only
> hardware that you desperately need to get going, but it freaks out on
> 802.11g encoded frames. Now if your AP is hostapd on a Linux machine,
> you'll want to change the mode. Hence, also the number of available
> rates change.
>=20
> Moreover, I think we can do better than just disallowing changes to the
> rate set, don't you think?

All of this is going to change anyway, but disallowing mode/rateset
changes while associated is definitely the right thing to do.

johannes

--=-rcBXHSTtwh1FmfOL/otz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR16kMaVg1VMiehFYAQKqaxAAlX5I3NM+bd+LMVtDbvNLP52YD5FD2KOh
i14fCsiYe0dOInngQERiYZHufKkUWNJVBErV0/L1mZCXia7QXYNStk81jyTHqiIS
yIjI+RtdBgTBkFgsj/AHLJ8cee/HqWQKRKIHE2MLCJc3uujid8VZshymxTFf50dJ
tBbQWPjuwfWI/DNf9t07NIaTbPH27LnIo3/eSGHscH0gHcwBvj6F0EGPwAJuNs7v
qHtdkFPwjwtmV7MDbsfmh8ak6e9GOUTasX3SGU19WlJF0fhjveqCTG0lOYZ2tARf
Tq6zcUQUB2MqJ4ilIXAU8TaFDbwUHbG93GKEgbiENPPO1T0H2Y2qZmOawc0P9txK
TinqMueuYy4vnVG3Gmibmws7i9w5PygPPMBi15+dUrchNfo7V8rqYnVfIaOq0zKl
DZ7OZk5CU+MtG37eURJDnGELCADS3QqsNlnCm7UGQRBW0idOsNdgqww62rbs6wl8
y/ySl5ufsEY8ttB/Xocp3dlpgrakgNTN7Bp+6XIN77GwcJxa2HpKXiZ6RJsUGkYc
KTYRFys1IIpkVToV/YYXmbHCC/lEM4nLCyfBRZgHvKVhInwie/en+m5KgCI5ZDSH
0l1RtEVKkFuqUTmupk+oPnH6by5F+a7PGccLUFHVWuG+69JidYCK5DoL0nHh3MwL
0tpVQRTawI0=
=EEQl
-----END PGP SIGNATURE-----

--=-rcBXHSTtwh1FmfOL/otz--

