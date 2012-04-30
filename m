Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:39807 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab2D3O5C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 10:57:02 -0400
Received: from [217.150.252.179] (confino [217.150.252.179]) (Authenticated sender: ordex@autistici.org) by localhost (Postfix) with ESMTPSA id 38833C8ADA
	for <linux-wireless@vger.kernel.org>; Mon, 30 Apr 2012 14:56:59 +0000 (UTC)
Date: Mon, 30 Apr 2012 16:58:04 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi warn_slowpath with 3.*
Message-ID: <20120430145803.GE2630@ritirata.org> (sfid-20120430_165739_918485_542ADA50)
References: <20120422182928.GA2854@ritirata.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cPi+lWm09sJ+d57q"
In-Reply-To: <20120422182928.GA2854@ritirata.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--cPi+lWm09sJ+d57q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 22, 2012 at 08:29:29PM +0200, Antonio Quartulli wrote:
> Hello,
>=20
> since linux-3.0 (I don't remember if it was the case even before), I'm ge=
tting
> this output in dmesg:
>=20
> [   53.662990] ------------[ cut here ]------------
> [   53.663016] WARNING: at drivers/iommu/intel-iommu.c:2911
> intel_unmap_page+0x14b/0x180()
> [   53.663047] Hardware name: Latitude E5420
> [   53.663066] Driver unmaps unmatched page at PFN ffd1a000


I see that I always get the same addr passed to the unmap function:

[   23.950535] Driver unmaps unmatched page at PFN ffd1a000

is it a coincidence?
I'm running linux-3.3.3 right now. I can try wireless-testing if it would h=
elp.

Cheers,


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--cPi+lWm09sJ+d57q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPnqh7AAoJEFMQTLzJFOZFGWgH/jT8KH/j1Val1MAyDf7Q3Gj9
0VSTI9AFnc2a6qsc6cThGgyvARdgnHaKpdre+WEpm8H8cwLwC1i7FOdkS8d4+6MK
gaBjvtcfVc7dRB4XOibVHjLQTP45HceedTEmDcYtaoUG/WRRTFVM1mU0j6roZw+O
ZfESHvLBKLCCVx2WyT+D+iHTXhSpsNS9JkLCQ5Gw2dU92+0aX10iBwGJ8KkDGyhV
V6cCxxGe+ZQNgtJIBdU2HVADOmeonpQxTRqzvDGrZ5z/Fyv93kpP6yZmUQ1sAEzN
xC0ufsNla8fyfpARexos1T3Fmluo3plWtm/H84FH6HJnHkk2rt3A2KHxVQJ6vCA=
=wU4I
-----END PGP SIGNATURE-----

--cPi+lWm09sJ+d57q--
