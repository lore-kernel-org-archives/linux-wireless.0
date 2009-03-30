Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44362 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbZC3Rlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 13:41:52 -0400
Subject: Re: [RFC] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>,
	Matthew Garrett <mjg@redhat.com>
In-Reply-To: <20090330173421.GB23749@khazad-dum.debian.net>
References: <1238349195.24972.5.camel@johannes.local>
	 <1238406057.24972.23.camel@johannes.local>
	 <20090330132911.GC11934@khazad-dum.debian.net>
	 <1238422114.5970.6.camel@johannes.local>
	 <20090330173421.GB23749@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/up0U+AvIQC0C/iIlVYG"
Date: Mon, 30 Mar 2009 19:41:18 +0200
Message-Id: <1238434878.5970.17.camel@johannes.local> (sfid-20090330_194155_228323_9FCB0AB3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/up0U+AvIQC0C/iIlVYG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[remove memebeam.org from CC, it doesn't have an MX]

Hi Henrique,

> There are three independent rfkill controllers in a thinkpad: UWB, WWAN,
> bluetooth.  They're hierarchically slaved to the master radio-kill switch=
 in
> the standard EPO way:  if the master switch is active, all rfkill
> controllers are forced active (all radios are killed).  If the master swi=
tch
> is not active, each rfkill controller can be independently set to kill or
> not their respective radio.

[snip]

Thanks for the explanation. I guess that kinda makes sense. One thing
I'm entirely sure about -- I had removed the sw default state setter --
I guess this code still requires then? I was thinking the sw default
state should be set for the devices it applies to, but it seems that if
the master rfkill switch is set to "transmitter off" then one needs to
set the default state (for all USB transmitters etc) to off, correct?

johannes

--=-/up0U+AvIQC0C/iIlVYG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0QQ8AAoJEKVg1VMiehFYW7EQAKQ0Tks5WWW4+Gjk413BvNA2
5kn1Eq70A1gUid6noE5jPEey/BVrOb8i03Reaz4eZF3947p6l0a2wMw6+ITvJgl7
UBJi+UXk5WUQRFJ0ozV6hcShPjRtCyB4nnpxEx9fcdHh/H/YuNJqhRrJG/AjATUx
gbohfyxCI+ao+H4XAs6MAd2Kl/5GCw1hYUf0AyKH/eQqwcwSZfDCt500LhuoWlou
cWtRr2VRDWkLzc4YHZiHsSE4VzTJDc4fAnNGAeODMm9ma+S/ZdjLW/Zl/NV3oRBc
QoB3Zb8kwM/8j0d8r+784aNEzYBl/H9ieZlOx2ruDRaqXHxizj2or3GMGtNHqhn2
6gGSbr4K/5dqelrXkf5eIzxnpHULEZaU82DtgGhhNKHCedn5aN5u8goQ45qhlkId
H291+QvQi1/X3ALeq2gJ+JCTq2BpaxzKjIqkXa61mqcKuqleE81GLtdVO6kHPqm7
yL62A16PBjPJeWBejs7w7INNR86vOVAt19c3Mt8Hharyi9h32rFUxVD1Bz2IGNkJ
8K2jnwRMxz9zICmB3TjFhj51WYM4GblT1txIwMmFdqgLQNMbyc1W43iRIu4iDCvw
38d1vsHNaVSx7cdmNxQ9ffzBlAf9Ka/S7Rl9HHNimD7NS9cq+JGp4C99ZWwt6IRS
sleeDFYrRCIsldxEkTUA
=6qrd
-----END PGP SIGNATURE-----

--=-/up0U+AvIQC0C/iIlVYG--

