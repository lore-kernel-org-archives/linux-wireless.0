Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:61682 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751796AbXIAFA4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 01:00:56 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Chr <chunkeey@web.de>
Subject: Re: [PATCH 2/2] p54: disable QoS on older firmwares
Date: Sat, 1 Sep 2007 00:58:55 -0400
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <46BFF10B.1090307@hhs.nl> <200708300152.27736.flamingice@sourmilk.net> <200708312327.28981.chunkeey@web.de>
In-Reply-To: <200708312327.28981.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6393742.HgTpDKi5qr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200709010058.59928.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart6393742.HgTpDKi5qr
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 31 August 2007 17:27, Chr wrote:
> This patch fixes a regression with older (pre 2.5.2.0) firmwares, that
> don't support the QoS queues yet...
>
Why bother allocating a temporary buffer for firmware version string? Just=
=20
keep a pointer to where it's located. (unless it's not null terminated..)

There's two extra unnecessary lines added to the end of p54_parse_firmware.

Thanks,
=2DMichael Wu

--nextPart6393742.HgTpDKi5qr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBG2PGTT3Oqt9AH4aERAlwHAJ9xndw/WkEdC4mjRDiKjhk5i/I6LgCfduFr
aSuRLP/WsO3cE+zGhlL32uY=
=79mt
-----END PGP SIGNATURE-----

--nextPart6393742.HgTpDKi5qr--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
