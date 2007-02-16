Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58995 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423429AbXBPJDv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 04:03:51 -0500
Subject: Re: round_jiffies for schedule_delayed_work?
From: Johannes Berg <johannes@sipsolutions.net>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <45D4A37D.8000203@linux.intel.com>
References: <1171489163.6093.30.camel@johannes.berg>
	 <20070215150615.GB3310@tuxdriver.com>  <45D4A37D.8000203@linux.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dgDJG4BTwQufpH6hR+gp"
Date: Fri, 16 Feb 2007 10:03:39 +0100
Message-Id: <1171616619.5220.70.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dgDJG4BTwQufpH6hR+gp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-02-15 at 19:16 +0100, Arjan van de Ven wrote:

> there is round_jiffies_relative() you can use for this kind of purpose...=
..

I actually looked at the code for it but didn't make the connection.
Sorry, I really should have. I'll see if I can do some patches.

johannes

--=-dgDJG4BTwQufpH6hR+gp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF1XNr/ETPhpq3jKURAjLmAJwPYS5QxW1j/GVf+avIVyPIBpPNjgCginVo
MrbVn/YCINgncW+4NSpf91I=
=P/0T
-----END PGP SIGNATURE-----

--=-dgDJG4BTwQufpH6hR+gp--

