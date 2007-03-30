Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49480 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965059AbXC3Kl3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2007 06:41:29 -0400
Subject: Re: [patch 3/5] A-MSDU Rx aggregation support
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: mohamed <mabbas@linux.intel.com>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <1ba2fa240703291412g6bf0b38fv86c64c9171601b5e@mail.gmail.com>
References: <1174909200.1364.56.camel@dell-4965.jf.intel.com>
	 <1175111599.5151.123.camel@johannes.berg>
	 <1ba2fa240703291412g6bf0b38fv86c64c9171601b5e@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sl4LNN3kODmvPKXV5Nul"
Date: Fri, 30 Mar 2007 12:40:35 +0200
Message-Id: <1175251235.19085.8.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sl4LNN3kODmvPKXV5Nul
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Could you please refrain from using HTML mail? It's making my life
unnecessarily complex.

>         Or something like that. Can you get frames w/o qos information
>         but with
>         ht info? If so, we'll need even more cases here :/
>=20
> No,  HT is QoS derived.

I thought so but wasn't sure if it was really always necessary to
include both.


> Yes this has to be put  into  ieee80211.h  -  and QoS is also 2 bytes
> so make it 0x0080 to stress it.
> HT It's defined be IEEE and not by WiFi (WME)

De facto standard...

Please trim your quotes.

johannes

--=-sl4LNN3kODmvPKXV5Nul
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGDOkj/ETPhpq3jKURAr8sAJ0Tzp5wwjhA9ReEk7T38RbODEkl6ACfRpfB
gnY41yIKkUjL0xbT+yIVmx8=
=+nKm
-----END PGP SIGNATURE-----

--=-sl4LNN3kODmvPKXV5Nul--

