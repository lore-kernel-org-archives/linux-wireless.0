Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45940 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754947Ab3JMTLR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Oct 2013 15:11:17 -0400
Message-ID: <1381691458.1301.63.camel@deadeye.wl.decadent.org.uk> (sfid-20131013_211120_876105_9F08FB8A)
Subject: Re: [PATCH] rtlwifi: Add new firmware files for rtl8192cu
From: Ben Hutchings <ben@decadent.org.uk>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: dwmw2@infradead.org, linux-wireless@vger.kernel.org
Date: Sun, 13 Oct 2013 20:10:58 +0100
In-Reply-To: <52541E22.2040904@lwfinger.net>
References: <1380234392-31062-1-git-send-email-Larry.Finger@lwfinger.net>
	 <52541E22.2040904@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ORaI+EEwE7bvq/YlWzXh"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ORaI+EEwE7bvq/YlWzXh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-10-08 at 10:00 -0500, Larry Finger wrote:
> On 09/26/2013 05:26 PM, Larry Finger wrote:
> > The vendor driver rtl8188C_8192C_8192D_usb_linux_v3.4.2_3727.20120404
> > includes new firmware files. These were extracted from data statements
> > in that driver to form these files.
> >
> > Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> > ---
> >   WHENCE                       |   3 +++
> >   rtlwifi/rtl8192cufw_A.bin    | Bin 0 -> 16116 bytes
> >   rtlwifi/rtl8192cufw_B.bin    | Bin 0 -> 16096 bytes
> >   rtlwifi/rtl8192cufw_TMSC.bin | Bin 0 -> 16116 bytes
> >   4 files changed, 3 insertions(+)
> >   create mode 100644 rtlwifi/rtl8192cufw_A.bin
> >   create mode 100644 rtlwifi/rtl8192cufw_B.bin
> >   create mode 100644 rtlwifi/rtl8192cufw_TMSC.bin
>=20
> I understand that you probably have too much to do, but I am inquiring ab=
out the=20
> status of this submission and "[PATCH] rtlwifi: Add new firmware files fo=
r=20
> rtl8188eu" that I sent on 09/27/2013.
[...]

I don't seem to have received them, but I assume the patches you sent
after this are the same again.

Ben.

--=20
Ben Hutchings
Beware of bugs in the above code;
I have only proved it correct, not tried it. - Donald Knuth

--=-ORaI+EEwE7bvq/YlWzXh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUlrwQue/yOyVhhEJAQqj1g/8DYhYUNgMTRIPfXun+nVBs9HHl8DNZkKv
1M2thaWQlV7v+JmoUERCKprAecCq14ISkLmrppRl4Mz+fawz0F/nUP5WKdgHhAZp
eCrKGV5+Hh6+LHX8LlP8bFGCy2c9JP8Pn6gfBWgtUPfDd9Zn/J9CntH2vwMgq0ah
xsjLZ1Qjiq5Vubqbt8AVV3un/IajUUFOgheBUe8M6u8RkV91D603ALW1O2G0ZfKn
ny3Ap5sk9bjUS1z42tyJPM6w0fQ04AjqPTp14I8lD0pv45n/OUSBgVb7g3C6nMuS
r3+VxN5UhWA8AeO5cJ76Kw8+dR7ZDqcEd17Iu+wvyDYRk2r3KC6QwpLJcieFCqpo
kOQEmLwP8D6uIpqnhZuFpRp4tzWku8fD4DoPQT59F+fqZFvqQUlzKJsnxRCKgw96
lSS/qx1nT0nOazP+KROWy0Ico3RwihVkhh7+qYI4FCB9YEIjShOMjpPXn2b2EQVg
YjgVG/52riAvbQHmTldlxRcfcEoSj64WCEVd3H+mQUtXgcWXeAdPlJQbU+NqGy3N
EZ5eFMRu2ezQwXKrHVELsZBxIhWusOL+zzQ+CPINuQ+Osyi3RE/2fBKKBjpP6bBm
leenM2oEp1DmeuTMgezqFV2uwSstczC/Gci1Hvpxi0wooVDtVeK/d9FW3RLbYJ1f
STW7hMqCoi4=
=m9Ib
-----END PGP SIGNATURE-----

--=-ORaI+EEwE7bvq/YlWzXh--
