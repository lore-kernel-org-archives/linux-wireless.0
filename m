Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4896 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbXHBQzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 12:55:12 -0400
Date: Thu, 2 Aug 2007 18:45:48 +0200
From: Erik Mouw <mouw@nl.linux.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC 0/10] Port of bcm43xx from softmac to mac80211
Message-ID: <20070802164548.GF13704@gateway.home>
References: <46b1fde0.b+weBDN75J0SPe2a%Larry.Finger@lwfinger.net> <200708021807.20649.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DSayHWYpDlRfCAAQ"
In-Reply-To: <200708021807.20649.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--DSayHWYpDlRfCAAQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 02, 2007 at 06:07:20PM +0200, Michael Buesch wrote:
> On Thursday 02 August 2007, Larry Finger wrote:
> > Driver bcm43xx is being ported from using SoftMAC to mac80211. For rewi=
ew,
> > this series of patches is being prepared; however, the final patch will=
 be
> > a single entity so that compilation during bisection will not break.

[...]

> I don't really want to review 10 huge patches that replace
> X by Y. If the code works, fine. Go for it. You get my ACK, if it works
> on the hardware where it matters. ;)

It might be a good idea to have two drivers for the same hardware so
it's easier to figure out if something broke or not. My linksys bcm4318
cardbus card works nice with 2.6.22 and I wouldn't like to lose that
functionality.


Just my 0.02 EUR,

Erik

--=20
They're all fools. Don't worry. Darwin may be slow, but he'll
eventually get them. -- Matthew Lammers in alt.sysadmin.recovery

--DSayHWYpDlRfCAAQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGsgo8/PlVHJtIto0RAiyJAJ42vknuth7i5h6uMvNAzxDdQKJAnACeKKro
59zIvsraeT6n9UouJTrVXiY=
=6ryb
-----END PGP SIGNATURE-----

--DSayHWYpDlRfCAAQ--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
