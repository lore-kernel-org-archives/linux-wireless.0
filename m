Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:38533 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbaDTWhJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2014 18:37:09 -0400
Date: Mon, 21 Apr 2014 00:36:51 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [wireless-next][PATCH 1/2] b43: ssb: refuse to support more
 than IEEE 802.11 core
Message-ID: <20140421003651.594f14c0@wiggum> (sfid-20140421_003752_027534_38F2F02E)
In-Reply-To: <CACna6rwjEP8qZ+SWQEOREmr=4wBJSgeNY_mG5GQpOWem7Jgrgw@mail.gmail.com>
References: <1398018659-17263-1-git-send-email-zajec5@gmail.com>
	<20140420205452.79a95330@wiggum>
	<CACna6rwjEP8qZ+SWQEOREmr=4wBJSgeNY_mG5GQpOWem7Jgrgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/dFn4sBEf8+D7yznyTBJvMi+"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/dFn4sBEf8+D7yznyTBJvMi+
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 20 Apr 2014 21:29:01 +0200
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> Do you think it's OK to push this small patchset and continue cleaning
> process later? I'm afraid it may take a lot of time to clean in
> completely and patchset would be huge. That's why I wanted to handle
> it with small steps.

Yes absolutely. The changes are huge and small steps are appreciated.
Try moving variables one group at a time. Not one huge patch that moves eve=
rything.
Nobody would be able to review that.

--=20
Michael.

----
Please use PGP/GPG encryption.
Key-ID: F532BE1D908D8B0E
--------

--Sig_/dFn4sBEf8+D7yznyTBJvMi+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTVEwGAAoJEPUyvh2QjYsOV6kP/32m9fCISuXRTxI1CN0Aer5a
SxBn/oXbldXKENzmQxFLa/gQ/FT9h89pyUnV4k8uycBrObhio/BKTHaOYGx7pwy9
ef2gMJw97cI+3q4MFYrcp3tPcRcUyo6xpe5Ntl5aE5PgAqtxEhZgxAN8E9k8yuHE
9eCv816qMmcxcpla9tBYPpGRfOexQCr5pRGl4W2qjv1NsTXCX4JxMaWEftP4tV6E
KQXOufNg52fdipxWD8mGGj/NBYEHNZnoQm4bPbJ5i7WXkBAjOJNLbiq5MfRGf0a3
idyiMrBJRT168jZY+pXU7Pn9Z7VeZZvRFt8JKbcFqpIIo7HSGV6u9hx3iMxe+piu
DHP8/nabUvWR0I/06J1bkH1NsGvWogDnNuw9RH+tRYqlyzNM8AfYiKLO77/7wPnu
c0zUZjcyw6eOeTVUJArSZmRBv10SRx0SGop0L/CyvBTBHt4T7St3dN/NlaRM4hS8
zokVLuMavkxBUZZtZOT5HpxzdR7NlS4eyCiOCXhggtryucR00+7470xaGL8wr8AH
3vjziy4wbJPvEgZM7m9yZo+as6KC9X/MbbN8zWfYW8Bf7y4c7rLciFi88SpQftEC
0oiv+65yFGdar47nwnucM6JtfmY3UVyxXQUsL47dBzTL3V9Y1gx5KZxa+3GVAqMS
ohFAYT7s43OYg6Ihmc8j
=PDCr
-----END PGP SIGNATURE-----

--Sig_/dFn4sBEf8+D7yznyTBJvMi+--
