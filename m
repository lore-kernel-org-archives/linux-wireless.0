Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40533 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYIKPqo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 11:46:44 -0400
Subject: Re: Crash with 2.6.27-rc6 with iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221145383.6309.12.camel@californication>
References: <E3A88D93-F0D2-476E-B162-08687FC602E3@linux.intel.com>
	 (sfid-20080911_100535_000722_EE099914)  <1221129382.6986.0.camel@johannes.berg>
	 <1221145383.6309.12.camel@californication>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Y1j2hFSpajCbmgXZXBaV"
Date: Thu, 11 Sep 2008 17:46:08 +0200
Message-Id: <1221147968.6986.28.camel@johannes.berg> (sfid-20080911_174652_696074_90FBCE66)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Y1j2hFSpajCbmgXZXBaV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-11 at 17:03 +0200, Marcel Holtmann wrote:

> > That looks like the use-after-free BUG_ON I've been getting with a 5k
> > card, do you have sl*b debugging enabled?
>=20
> I have CONFIG_SLUB_DEBUG=3Dy in this kernel. Including all sorts of kerne=
l
> debugging features enabled. Anything else I would need to give better
> feedback?

No, I have no idea, but maybe Tomas doesn't have them enabled? The
message right before the BUG_ON says something about 0x6b... I have no
idea what's causing this, just saying that it's most likely the same
thing and I was able to capture the full message.

johannes

--=-Y1j2hFSpajCbmgXZXBaV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIyT08AAoJEKVg1VMiehFYRFQP/1GbylitDjxLqzCEW6pWaz6s
zm9tF+i6BJaUHOZYy+qxa3wdjPhEz7W7qltCQ4nrfApvyvbOEaJCa+ZRv6Z2Ngju
hZivErZVgfNXooNMTltTAgxpqiZh2zEa5XenyQp1QZS3IZNnhHY8qbcxpo+1Jy2z
uIARkORKIloREGmrSHcQDETGpzOn8cnORbJg9PJt4g5YCbHlSVH+OB39oe9031fJ
KFbvMSJ3pSTlNcYm40E9vcEI9RaLMqpZ7yA8p+TyGddBoqGUbnNEn3Fi0Ts+G4hI
WRpIrmVvoVQ8Ueij5S9/ybODOLFVtXy0S/KgR5QDuwubOH73P07+dLZ/ih66rO/0
dbnvXjJC/kvdvPFW9AwwOjFgMIKuOxPKgBkg/T88tKaa3YvOO+q/E6kAXwGfI/E1
ox993KFVoHsFkHeuq6dMKQEjyPL2yTxrwLN09vEZSm/xoakiBy1ryYM9O3K21hA/
BbUwetPPtIkV82jcG1XO2o3NSzBMG6lOvW10Xw3fl8xdVv6biYAaywLtpntyTX45
JsMlKma6FgaiqeAx19GKVp9HAyr+7hozGmbmHUpdEACuJ+06rbjqAnbsaUzEER5v
epPDAXsybbY1ZbR7Bw9wdVXF3GlTf/tUfyACrZD0JsG7KGppPJ/F6ivraxxARN/i
sXivxsItac+65rwGAWTC
=dmJk
-----END PGP SIGNATURE-----

--=-Y1j2hFSpajCbmgXZXBaV--

