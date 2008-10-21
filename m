Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60488 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbYJUHiJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 03:38:09 -0400
Subject: RE: New Regulatory Domain Api.
From: Johannes Berg <johannes@sipsolutions.net>
To: gwingerde@kpnplanet.nl
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Zhu Yi <yi.zhu@intel.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <79124FD53D2E084387D88C71BEB48F3EDD3625@CPEXBE-EML29.kpnsp.local>
References: <20081015112517.GF6509@tesla>
	 <1224484685.18024.5.camel@johannes.berg>
	 <43e72e890810192346q5e0eadbcm26febe45392a2172@mail.gmail.com>
	 <1224485431.18024.12.camel@johannes.berg>
	 <43e72e890810192359g2bc75316v49377ddc9eded934@mail.gmail.com>
	 <1224487340.24677.192.camel@debian.sh.intel.com>
	 <1224520999.9386.72.camel@californication>
	 <1224552899.24677.245.camel@debian.sh.intel.com>
	 <43e72e890810201842o44db616ekd8d5bc66cd1006f@mail.gmail.com>
	 <1224554323.24677.248.camel@debian.sh.intel.com>
	 <43e72e890810201937l3be24156t2172590138fda132@mail.gmail.com>
	 (sfid-20081021_043804_334625_50CEDAE0) <1224572722.27899.87.camel@johannes.berg>
	 <79124FD53D2E084387D88C71BEB48F3EDD3625@CPEXBE-EML29.kpnsp.local>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-S5R/tTVrQhgokr8e80YV"
Date: Tue, 21 Oct 2008 09:37:56 +0200
Message-Id: <1224574677.27899.94.camel@johannes.berg> (sfid-20081021_093814_201459_732CD0CB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-S5R/tTVrQhgokr8e80YV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-21 at 09:30 +0200, gwingerde@kpnplanet.nl wrote:

>=20
> This would help me with rt2x00 as well, provided that the
> regulatory_hint(alpha2) function gets the bandflags as well.

No, that's not possible.

> rt2x00 EEPROM contains 2 SKU's, one for 2.4GHz band and one for 5GHz
> band, which don't necesarily have to agree with each other. Having
> these bandflags in here, allows me to hint these different SKU's to
> the regulatory framework, and handle the device indications correctly.

I thought you didn't have SKUs but actual country information. Why would
a card be manufactured for 2.4 GHz operation in the US and 5 GHz
operation in Chile or something? Anyway, given that those values are
apparently invalid most of the time anyway...

johannes

--=-S5R/tTVrQhgokr8e80YV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/YbRAAoJEKVg1VMiehFYyq4P/1UQpIk5fpN1mDLWia/0Ccyh
r1e9gQ+i20xLC9lmmzhObgx93hi0+L64vWvI0QC6V3UL+qnk3RxbfKwv+lnkRW5C
lLNzg82iowGet5CKho4F+PNOGUW9rOx/WP6RBhDPO2DHdk/n9lvstfwJqop4w38U
xvyYSaTWTjMmDn9yaLklsGi72jOXHNh1MzIo4soNtJlwEnOIsttgvCedKQH3cyaO
hSFL4LxrZ+fW/zzwlONUNaNKkMnqQVHcFW4XSK9cKG72ODjsYy1udvHdQeyFya6n
tmU05dzUMxDg70FCarzzVrtGtkPtSt9q1tVNDI69dgHmoYrJsEfi8KsYfLI1kB/T
Dgwqgu9pxXxiQa5jx1mGefVT62o+6bj1EGx4dUbgF8RFUjh4ils6fTD0hb+8ECea
RaP1WXG/UZ4TgKvDiudc+Vo357AFnm+dJbj3OYeIXA07LOG5D3TkkZEHs2tGuKs0
CLShG1CtB2Y2g/dgl5SDAWJy0Aw0FA1uN/0VAubGHrKe/m8gdhcFTDHQ2mys0/iM
vxwx4n1+JDLEeEnO6yd9rVy6Y6ck7lMB3iQiZdgCFhb+uXvUS3JDlg2fZe+aUTMQ
cZK0T83hEj5YWIJIcbdW4DC2JDTzZxTh++vSAS2PyuGkGtM5Ox6Tlg8MJr+GKSjB
t0qOgS90SPr3WQe+nrDN
=eim+
-----END PGP SIGNATURE-----

--=-S5R/tTVrQhgokr8e80YV--

