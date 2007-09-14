Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48010 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467AbXINSik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2007 14:38:40 -0400
Subject: Re: iwlist and network-manager bug report
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: jt@hpl.hp.com, linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1189794820.2508.22.camel@xo-3E-67-34.localdomain>
References: <1189526874.6161.30.camel@johannes.berg>
	 <1189610572.5644.28.camel@xo-3E-67-34.localdomain>
	 <20070912170153.GA25785@bougret.hpl.hp.com>
	 <1189667496.6161.77.camel@johannes.berg>
	 <1189707493.1329.1.camel@johannes.berg>
	 <1189793380.2508.2.camel@xo-3E-67-34.localdomain>
	 <1189794311.3974.49.camel@johannes.berg>
	 <1189794820.2508.22.camel@xo-3E-67-34.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ikYVD1rmdqqR4O18a/bR"
Date: Fri, 14 Sep 2007 20:39:57 +0200
Message-Id: <1189795197.3974.51.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ikYVD1rmdqqR4O18a/bR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-09-14 at 14:33 -0400, Dan Williams wrote:

> For whatever reason, driving wpa_supplicant with D-Bus is a lot more
> reliable than talking to it over the unix domain socket.  I've long
> suspected that's part of the issue with random failures of
> wpa_supplicant in situations where the results between NM-driven and
> plain wpa_supplicant are different.

Yeah, you mentioned that.

> Would be interesting to see some wpa_supplicant debug output from Ben's
> machine though to see where it's failing and what info NM is pushing to
> it.

Except it's not Ben but David and it's a lot harder to coerce useful
output from him when he's in Spain ;)
Though I can ask him to try and then send me the syslog.

johannes

--=-ikYVD1rmdqqR4O18a/bR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD4DBQBG6tV9/ETPhpq3jKURAmBgAJj1HsdAM6e32S1hGbTxF0MwGFosAJ9Zxl4B
kRjeD6d0z4sGhiTYaRrJEA==
=KZ2s
-----END PGP SIGNATURE-----

--=-ikYVD1rmdqqR4O18a/bR--

