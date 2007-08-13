Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49146 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S970961AbXHMJCA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 05:02:00 -0400
Subject: Re: [PATCHv2] mac80211: dynamic wep
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Volker Braun <volker.braun@physik.hu-berlin.de>,
	linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <200708130054.57899.flamingice@sourmilk.net>
References: <pan.2007.08.10.23.31.32@physik.hu-berlin.de>
	 <200708130054.57899.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jnlH6hgDIL3aiMYwN5Z9"
Date: Mon, 13 Aug 2007 10:54:43 +0200
Message-Id: <1186995283.27916.60.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jnlH6hgDIL3aiMYwN5Z9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-13 at 00:54 -0700, Michael Wu wrote:

> This part seems fairly evil. I suspect a better solution here is to allow=
=20
> unencrypted frames when the interface is dormant (netif_dormant()) and th=
en=20
> we might be able to get rid of the specific check for WEP.

Might that address Tomas's concern with EAPOL too?

johannes

--=-jnlH6hgDIL3aiMYwN5Z9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwBxT/ETPhpq3jKURAtm5AKCMC1X3b4SGH98wrNtV3pC+2B4Q7ACffADP
xPVDvHmjbFcfWJxMbKUzvyA=
=n8XG
-----END PGP SIGNATURE-----

--=-jnlH6hgDIL3aiMYwN5Z9--

