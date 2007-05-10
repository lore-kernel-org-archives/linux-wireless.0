Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:8453 "EHLO annwn13.rutgers.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755108AbXEJSPX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 14:15:23 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V4] mac80211: Add support for SIOCGIWRATE ioctl to provide rate information
Date: Thu, 10 May 2007 14:14:33 -0400
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <46435ace.oKGIdoTGgDdGQs74%Larry.Finger@lwfinger.net>
In-Reply-To: <46435ace.oKGIdoTGgDdGQs74%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1190810.kb9ukj1uY2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705101414.37098.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1190810.kb9ukj1uY2
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 10 May 2007 13:47, Larry Finger wrote:
> +	if (sta->txrate >=3D 0 && sta->txrate <=3D local->oper_hw_mode->num_rat=
es)
sta->txrate will never be negative unless there's a bug somewhere so that=20
check should be removed.

'<=3D' isn't quite right. sta->txrate =3D=3D local->oper_hw_mode->num_rates=
 is not a=20
valid index.

=2DMichael Wu

--nextPart1190810.kb9ukj1uY2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGQ2ENT3Oqt9AH4aERAiDLAJ4gWpfiF0ybVpbAsRLb+Z+LRB+4MgCdEj9h
20GPwJPJYsE/HyyJ1D8QD7A=
=Dh+r
-----END PGP SIGNATURE-----

--nextPart1190810.kb9ukj1uY2--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
