Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60810 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbXEJRJX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 13:09:23 -0400
Subject: Re: Specifing rate control algorithm?
From: Johannes Berg <johannes@sipsolutions.net>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <46434596.6010908@linux.intel.com>
References: <464253CE.2030504@linux.intel.com>
	 <20070510132756.2ca660a0@midnight.suse.cz>
	 <46434596.6010908@linux.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RHRaPd/lGxhAo4CN0PkI"
Date: Thu, 10 May 2007 19:11:44 +0200
Message-Id: <1178817104.3806.33.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RHRaPd/lGxhAo4CN0PkI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-05-10 at 09:17 -0700, James Ketrenos wrote:

> This commit simply adds an optional rate control algorithm name
> parameter to ieeee80211_register_hw.

Why don't we just add a char *preferred_rate_control; to the hw
definition structure instead? That way, we can even show it in
sys/debugfs later so the user will still know what the driver preferred
after changing it.

johannes

--=-RHRaPd/lGxhAo4CN0PkI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGQ1JQ/ETPhpq3jKURAq+/AKCSRtUd4zb+BeSMg8nw7QO/errJTACfXYdE
GUMLEo6bS00pDOHwlWCE7iM=
=vXBZ
-----END PGP SIGNATURE-----

--=-RHRaPd/lGxhAo4CN0PkI--

