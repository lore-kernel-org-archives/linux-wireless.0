Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:35959 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754214AbXEQD4x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2007 23:56:53 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
Date: Wed, 16 May 2007 23:55:30 -0400
Cc: James Ketrenos <jketreno@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <464B7B7C.5080800@linux.intel.com> <200705162151.32910.flamingice@sourmilk.net> <464BC459.4030105@garzik.org>
In-Reply-To: <464BC459.4030105@garzik.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2635872.XGUDnyOYyr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705162355.35495.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2635872.XGUDnyOYyr
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 16 May 2007 22:56, Jeff Garzik wrote:
> This is the maintainer's personal preference.  I put them in all my
> drivers, and they look perfectly fine here.
>
I consider it generally ugly and to be avoided. These seem to be placed onl=
y=20
in the mac80211 callbacks so it's more of a tool to figure out when mac8021=
1=20
uses callbacks.. doesn't really belong here IMHO.

But.. if James likes them, fine. I haven't seen anything better using the g=
cc=20
mcount stuff Christoph Hellwig was talking about so this is the only option.

=2DMichael Wu

--nextPart2635872.XGUDnyOYyr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGS9I3T3Oqt9AH4aERAgc2AKCYzTbBl9uKrhkb1BI+xAJTVs/mlwCggVcl
r1NW356v8XwLz/Xq24+Kc1s=
=V1VC
-----END PGP SIGNATURE-----

--nextPart2635872.XGUDnyOYyr--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
