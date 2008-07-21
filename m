Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:4497 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757898AbYGUBNa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2008 21:13:30 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1212415137.21075.10.camel@localhost.localdomain>
References: <1212354884.4722.26.camel@deadeye.i.decadent.org.uk>
	 <1212415137.21075.10.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Nql5g9kDPDusgJPxInES"
Date: Mon, 21 Jul 2008 02:12:00 +0100
Message-Id: <1216602720.5858.33.camel@deadeye.i.decadent.org.uk> (sfid-20080721_031353_599397_D8497B57)
Mime-Version: 1.0
Subject: Re: IW_SCAN_CAPA_ESSID vs hidden ESSID
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Nql5g9kDPDusgJPxInES
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-06-02 at 09:58 -0400, Dan Williams wrote:
<snip>
> One issue with ipw2200 specifically is that it does aggressive
> background scans, and those background scans will supercede a scan
> request for a direct SSID scan.  I posted a patch for that issue to
> linux-wireless@ but need to rework some bits of it.  That made the issue
> significantly better.
>=20
> If possible, can you apply the attached patch and rebuild and see if
> that helps it?

Somehow I never got round to doing this.  But I see that a similar patch
from you made it into v2.6.26, so I applied that and it did fix the
problem.  Thanks a lot!

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-Nql5g9kDPDusgJPxInES
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBIg+Jb79ZNCRIGYgcRApwzAJ4hzFKxPh+PbQDBkTo0SQsogq//BgCfYvfs
80Rfnzn9L4f4oCWwacFA2wU=
=vC+V
-----END PGP SIGNATURE-----

--=-Nql5g9kDPDusgJPxInES--
