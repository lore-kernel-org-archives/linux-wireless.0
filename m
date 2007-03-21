Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:13597 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751325AbXCUSKD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2007 14:10:03 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH 3/5] d80211: Set carrier status for STA interfaces
Date: Wed, 21 Mar 2007 14:08:51 -0400
Cc: linux-wireless@vger.kernel.org
References: <20070228203943.11473.95222.stgit@magic.sourmilk.net> <20070228203943.11473.36193.stgit@magic.sourmilk.net> <20070321182505.2260a9a8@griffin.suse.cz>
In-Reply-To: <20070321182505.2260a9a8@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2078350.9hG2hUJ1g2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703211408.58634.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2078350.9hG2hUJ1g2
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 21 March 2007 13:25, Jiri Benc wrote:
> On Wed, 28 Feb 2007 15:39:43 -0500, Michael Wu wrote:
> > This makes STA interfaces set the carrier status based on the current
> > association status.
>
> Does this really work? Last time I checked, when the carrier is off, no
> frames are sent to hard_start_xmit.
>
This applies only to STA interfaces, whose frames to the master dev are=20
dropped anyways if there is no association.

=2DMichael Wu

--nextPart2078350.9hG2hUJ1g2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGAXS6T3Oqt9AH4aERAskiAJ4hzOnEcMTJKh/jnufRyZnOzaguDACggM7g
HVSm8S6BVj7XR/bE/C/Zrm8=
=zR32
-----END PGP SIGNATURE-----

--nextPart2078350.9hG2hUJ1g2--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
