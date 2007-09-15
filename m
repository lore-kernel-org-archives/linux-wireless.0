Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57346 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbXIOJIG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Sep 2007 05:08:06 -0400
Subject: Re: Fw: build #301 failed for 2.6.23-rc6-g0d4cbb5 in   linux/drivers/net/wireless/libertas/
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-wireless@vger.kernel.org,
	Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
In-Reply-To: <20070915020251.2b5b8adc.akpm@linux-foundation.org>
References: <20070915020251.2b5b8adc.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Swute9bIKN5A2yy7umIo"
Date: Sat, 15 Sep 2007 11:09:19 +0200
Message-Id: <1189847359.23521.2.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Swute9bIKN5A2yy7umIo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-09-15 at 02:02 -0700, Andrew Morton wrote:

>   Building modules, stage 2.
>   MODPOST 353 modules
> ERROR: "libertas_remove_mesh" [drivers/net/wireless/libertas/usb8xxx.ko] =
undefined!
> ERROR: "libertas_add_card" [drivers/net/wireless/libertas/usb8xxx.ko] und=
efined!
> ERROR: "libertas_send_tx_feedback" [drivers/net/wireless/libertas/usb8xxx=
.ko] undefined!
> ERROR: "libertas_prepare_and_send_command" [drivers/net/wireless/libertas=
/usb8xxx.ko] undefined!
> ERROR: "libertas_remove_card" [drivers/net/wireless/libertas/usb8xxx.ko] =
undefined!
> ERROR: "libertas_add_mesh" [drivers/net/wireless/libertas/usb8xxx.ko] und=
efined!
> ERROR: "libertas_process_rxed_packet" [drivers/net/wireless/libertas/usb8=
xxx.ko] undefined!
> ERROR: "libertas_interrupt" [drivers/net/wireless/libertas/usb8xxx.ko] un=
defined!
> ERROR: "libertas_activate_card" [drivers/net/wireless/libertas/usb8xxx.ko=
] undefined!

I really wonder how this thing works at all. All these symbols need to
be exported. I'm pretty sure we've had this before.

> CONFIG_LIBERTAS=3Dy
> CONFIG_LIBERTAS_USB=3Dm

johannes

--=-Swute9bIKN5A2yy7umIo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG66E+/ETPhpq3jKURAmTrAJ94vsAp4lsiPkfoxrXmnhM9NCOnOQCdFj6P
Sqg8xTp24e+FKmVUTD0p8DE=
=1BMP
-----END PGP SIGNATURE-----

--=-Swute9bIKN5A2yy7umIo--

