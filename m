Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server8.tchmachines.com ([216.180.241.250]:56647 "EHLO
	server8.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbXCDFTF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2007 00:19:05 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Helge Deller <deller@gmx.de>
Subject: Re: [PATCH] p54 various cleanups
Date: Sun, 4 Mar 2007 00:18:55 -0500
Cc: linux-wireless@vger.kernel.org
References: <200702272219.58919.deller@gmx.de> <200702271826.07149.flamingice@sourmilk.net> <200703021945.20954.deller@gmx.de>
In-Reply-To: <200703021945.20954.deller@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1563417.JtkKulCAIT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703040019.00159.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1563417.JtkKulCAIT
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 02 March 2007 13:45, Helge Deller wrote:
> -static unsigned int tx_ring_size =3D 16;
> -static unsigned int rx_ring_size =3D 16;
> -static int debug =3D 1;
> +static unsigned int tx_ring_size __read_mostly =3D 16;
> +static unsigned int rx_ring_size __read_mostly =3D 16;
> +static int debug __read_mostly =3D 1;
>
Hm, sure why not..

> -const u8 rtl8225_agc[] =3D {
> +const const u8 rtl8225_agc[] =3D {
What does const const do?

> -static const char *rfs[] =3D {
> +static const char * const rfs[] =3D {
?

BTW, you should have an updated summary for this patch.

Rest of the patch looks okay to me.=20

Thanks,
=2DMichael Wu

--nextPart1563417.JtkKulCAIT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF6lbET3Oqt9AH4aERAhvPAKC5sYKeUWE8paNFPEEzY1JJtfie/ACfcOnM
+lrebfbO+/v/8gfHybEoSMk=
=mo+1
-----END PGP SIGNATURE-----

--nextPart1563417.JtkKulCAIT--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
