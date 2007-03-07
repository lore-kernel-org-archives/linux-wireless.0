Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:11481 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965574AbXCGRWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2007 12:22:07 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] prism54usb: Fix hail of warnings on 64bit platforms
Date: Wed, 7 Mar 2007 12:21:12 -0500
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
References: <20070307164020.16944e32@lxorguk.ukuu.org.uk>
In-Reply-To: <20070307164020.16944e32@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3115638.HeVOGtHyun";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703071221.19580.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3115638.HeVOGtHyun
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 07 March 2007 11:40, Alan Cox wrote:
> If you want to cast a pointer to a small value then start by turning it
> into an unsigned long so the compiler knows what is going on.
>
I already have a fix for that - just haven't pushed it up to wireless-dev y=
et.

> Personally I find the whole approach used by this driver for types of
> registers (which are really USB register numbers) utterly perverse...
>
The same register offsets are used in the PCI driver since version 1 usb=20
devices are really just the PCI device with a usb->pci bridge chip attached.

=2DMichael Wu

--nextPart3115638.HeVOGtHyun
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF7vSPT3Oqt9AH4aERAk/+AJ47KBW4bG3o0v6E2HsiFeZIL+el+ACgnL15
Vqmt1hL7herq5ZcLS8Krg1Y=
=hFX9
-----END PGP SIGNATURE-----

--nextPart3115638.HeVOGtHyun--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
