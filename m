Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45165 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760071AbZA2AGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 19:06:08 -0500
Subject: Re: [PATCH resend] crda: rename nl_handle to nl_sock for libnl-2.0
From: Johannes Berg <johannes@sipsolutions.net>
To: pat-lkml <pat-lkml@erley.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4980EDC8.4050204@erley.org> (sfid-20090129_004437_360979_B9D4728F)
References: <4980EDC8.4050204@erley.org>
	 (sfid-20090129_004437_360979_B9D4728F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NHQctUeDaqU2ak90E1gU"
Date: Thu, 29 Jan 2009 01:05:26 +0100
Message-Id: <1233187526.16048.95.camel@johannes.local> (sfid-20090129_010618_434437_8E75ED88)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NHQctUeDaqU2ak90E1gU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-28 at 18:44 -0500, pat-lkml wrote:
> Upstream has renamed nl_handle to nl_sock.  Update crda to the new names
> and add #define for libnl-1.1.

But libnl-2.0 comes with a define too:
#define nl_handle nl_sock

you just need to include the right headers, no?

johannes

--=-NHQctUeDaqU2ak90E1gU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgPLEAAoJEKVg1VMiehFYJ44P/R0Wc7GkrLprPQd4xHdBF/56
CbFF5dxni8nSs7yI6MQwxKg1UcPzlph28DAYi4q6i+5vPZnmEkfeqkK9lC9X/HUK
CICscztkb5zJmbI4ByK+rIEB5VhaMXCxb09mvEe6+kPUiVIcArzippJRZyCPkkjY
xD8l0DbANDg94iXsXh/OYrOMdUVcqu8y9R/FXSZpE76IcaNzs/5lj3SCtMSPDuYU
8aXfqR6qk9jYQ9HJIrJcm+k4wDQpBvxhSPFmHwTVJXFoHVHDfva18h+VMRY9bdMV
Vo8yNM4WnsY8PMVuaaV7h+DLWUyXNj1jlLQMYFqkx5ISEi+Ts/CnEAG6MTOHqfBk
Dai/vmGgmVXWLwRexj5AuPclYTCu8Xtte3riYpnzt6u/5ZeGOOMarXEadIPvWFi7
QmWrRBhRLx0x1kVEiqrVxt13KNNz1F8E99/puAe9le+WZRxT5eOS5Ob1WKH7wqUO
ePPeOMj8jmuIGgjED2cJyl9CZVZP3E2lHXI7EmsQmXj9qiiIFLQmk3LcAKk7vZDB
XrmrNPq71uAKtPlSRYS7/D5v0vJl+8lEowMj6u3VBYiFrNFKM0kdK1PV6yUIGtVD
wIdkFmbQRzcPsgX7UIRXdQoHJn5PfxN+6+jFrAU81iz+DMWh9rmhxqfi+N454NHe
PwnsByyu8VpzkHjUUrRd
=91GA
-----END PGP SIGNATURE-----

--=-NHQctUeDaqU2ak90E1gU--

