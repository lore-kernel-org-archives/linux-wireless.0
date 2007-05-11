Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55812 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499AbXEKLea (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2007 07:34:30 -0400
Subject: Re: Specifing rate control algorithm?
From: Johannes Berg <johannes@sipsolutions.net>
To: jketreno <jketreno@linux.intel.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <46437446.6030302@linux.intel.com>
References: <464253CE.2030504@linux.intel.com>
	 <20070510132756.2ca660a0@midnight.suse.cz>
	 <46434596.6010908@linux.intel.com> <1178817104.3806.33.camel@johannes.berg>
	 <46437446.6030302@linux.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pFFW6sy8uc4EqjKDStIB"
Date: Fri, 11 May 2007 13:36:52 +0200
Message-Id: <1178883412.8896.2.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pFFW6sy8uc4EqjKDStIB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-05-10 at 12:36 -0700, jketreno wrote:
> Johannes Berg wrote:
> > On Thu, 2007-05-10 at 09:17 -0700, James Ketrenos wrote:
> >=20
> >> This commit simply adds an optional rate control algorithm name
> >> parameter to ieeee80211_register_hw.
> >=20
> > Why don't we just add a char *preferred_rate_control; to the hw
> > definition structure instead? That way, we can even show it in
> > sys/debugfs later so the user will still know what the driver preferred
> > after changing it.
> >=20
> > johannes
>=20
> How's this?

Looks good to me, requires no driver changes and adds useful
functionality.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

(What prompted me to think of this was the LED subsystem that allows you
to specify default triggers for some LEDs)

johannes

--=-pFFW6sy8uc4EqjKDStIB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGRFVT/ETPhpq3jKURAuamAJ4qoGd/3Uy7NnadiPB6BIVqq9YWygCgslb/
VzaOyPA4UrdR1DGOjIw2GDo=
=ZuRN
-----END PGP SIGNATURE-----

--=-pFFW6sy8uc4EqjKDStIB--

