Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52164 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbZBQTnb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2009 14:43:31 -0500
Subject: Re: Missing link quality with wireless-testing
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1234896777.4678.7.camel@californication> (sfid-20090217_195251_321967_5E2E0AB8)
References: <1234896777.4678.7.camel@californication>
	 (sfid-20090217_195251_321967_5E2E0AB8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9SPuVS4aZyc+TSI03aXN"
Date: Tue, 17 Feb 2009 20:43:26 +0100
Message-Id: <1234899806.29785.35.camel@johannes.local> (sfid-20090217_204344_725950_77F85EFF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9SPuVS4aZyc+TSI03aXN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Marcel,

> I have been running the wireless-testing kernel from yesterday and I
> realized that something with the link quality values from scanning
> results is broken.

What exactly is broken by this? Wext never guaranteed that 'qual' values
be present, and thus any application that breaks from not having 'qual'
is broken anyway.

johannes

--=-9SPuVS4aZyc+TSI03aXN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJmxNbAAoJEKVg1VMiehFYutoP/AwkVLb5g16FYpN9DZ65WDvE
g93QpAzNgmf2PWzTOfUo4HM3x2EraW8vmpYb8/D7VU1GOiNnaGozDu5UV2xlwO5b
xZTrICH3GbXjChF3842GhTKVCUSdvX5JSV4TNFHMSRV3VY653fcNraxivXgqQ3sh
yggYj/ICrn19wzajY16IZ5R8UtGvolRgYW0rhma2nDyrENTV14XAl5tJWX9nnfg/
d+bsBJOEIffW8OdjHeZXjNt4HK6iVNaelAo0vUrbiSPKsiVTqZR+62L069T12dQ5
HVaszs5tz5bsALEVwylLsI7ghTI1Tv7oKk6GQD5/2ptfnEyAbB8qL6/YP3jR0261
4ZvyzPCvhCV0reJC1VTL+EtQkz6bpanjfpYQ33YSDvdMwwse646mfgE0DWHgw9p5
UkGXTfkiN4+o20Sc0LxgbmgtQ9FFR9NPYc3RnCCS4CfGNFR6QlZRneAhrLEmWsV8
sMjS6v3Cwj1WA1coOg5D2STTODg3eQWU+4tQQe7qk1jdb4+3BvAlODVGs95I9pMR
zzf9wdcJkHMwJKyhBCetT+Z+gb0Rva92Y0qecNU7bEXcqFRqy0/bxXRPxF6/GD29
95vZNtUOVkBSWekQV1GFiaGSq5szxMTqpZ9bStomH2A2BrA2lRdul8Lx+LyvQIZn
6HYlNgdVt5I4I1U4Un5g
=k1iX
-----END PGP SIGNATURE-----

--=-9SPuVS4aZyc+TSI03aXN--

