Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45745 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbYCRJSU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2008 05:18:20 -0400
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request
	a Phase 2 key
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <20080318080435.GA5308@jm.kir.nu>
References: <1205751455.1614.25.camel@johannes.berg>
	 <1ba2fa240803170540n2e6fb398p84abfb34e4124042@mail.gmail.com>
	 <1205758276.1614.45.camel@johannes.berg>
	 <1ba2fa240803170636t6158c0a8vb180f71352208548@mail.gmail.com>
	 <1205761758.1614.79.camel@johannes.berg>
	 <1ba2fa240803171212s36f85306i6f47ed9fa725b90@mail.gmail.com>
	 <1205781593.16475.20.camel@johannes.berg>
	 <1ba2fa240803171239l6b07ba4ch2b2aaca5e7fa0506@mail.gmail.com>
	 <1205784255.16475.33.camel@johannes.berg>
	 <1ba2fa240803171327r4c817228kc4f248abf0a0cea@mail.gmail.com>
	 <20080318080435.GA5308@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-I2wJr/A+oj7jmSyxKK30"
Date: Tue, 18 Mar 2008 10:18:00 +0100
Message-Id: <1205831880.16475.43.camel@johannes.berg> (sfid-20080318_091824_352112_70C2438B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-I2wJr/A+oj7jmSyxKK30
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> At least the original d80211 design supported multiple SSIDs per BSS and
> yes, as far as kernel code is concerned, this was done in the identical
> way for both multi-SSID and dynamic-VLAN (RADIUS assigned). A new
> virtual interface is added for both cases and STAs are bound to the
> specific virtual interface based on MLME/RADIUS results.
>=20
> However, I do not think I ever merged multi-SSID support into the open
> source version of hostapd, so it is quite possible that only the
> RADIUS-based VLAN assignment is currently used since multi-SSID support
> is inferior to multi-BSS support for number of reasons. Anyway, that
> does not change what mac80211 would support should one ever really want
> to enable multi-SSID support with a single BSS. I don't see much need
> for that, though, if one can use virtual BSSes.

Ah. I guess that requires hiding the SSID though?

johannes

--=-I2wJr/A+oj7jmSyxKK30
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9+Ix6Vg1VMiehFYAQKxyQ//cB+SCvYro1q/VBmegjZtvkjZgWFNaJgN
PB4jNcDdhQqJHEQAJLXu29iWNi5jq2gakyvdpQhTGCisGXx7xN8YeJ9xZ1uGhoAF
QgKSEer/lwL7T4OUtlAZcl9pohhssM7/36wkSuo9cdgStFdNP/hzxJoY7rh4Opv3
c+L2aN7idn4JveA58a63nJ8D2JjGvbE4xRK8v5uCpJ7Dpk2wBt+F54WcYMvnQ3JK
k/GhAiyxeZP9Eq5LVKb1jzg3NAPCrlNPv7C7g7iKHtEcgg6RqB49BOSand/lpzmt
rGlBsr+NWkfbME5J7gjPcWZ70K9ZK5ffTrJ66tS4JcSh0JiEpmfkjKeK1wyvOevE
FQ74gUbTAzNm8QmTBEDWFg0nkXD6BnaCxyZhRfpwnSfl9TzlfO4XENmjBcVeeffW
sKfp45z769sKC4LuYIX58LWrOpD9ULwR6aCHoyIn0B/flXUAvU+/maFnj92/SXw+
+QzTv3CGpfBm+JnoGZ+8kUQZllcalMOZLRy8itIsxEXr7TqJ0dHfdVFaUZ3ivucs
q0P9K80ZY5cjqwtsrV/p07jG00n8HlKIxE7BN57xnzvYcdvyd+Lkx0c6nOsWpjCI
Aya16PHNIDXXuLy8Ld6lEc5ayhNfBP2yhIuS/avHW/AV98SNgUeUfXghnDTS/Uok
bJCrfdDY6yM=
=c8QY
-----END PGP SIGNATURE-----

--=-I2wJr/A+oj7jmSyxKK30--

