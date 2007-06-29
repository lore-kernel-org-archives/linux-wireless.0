Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56206 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758135AbXF2JUI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2007 05:20:08 -0400
Subject: Re: build #301 failed for 2.6.22-rc6-g0471448 in  drivers/net/wireless/libertas/usb8xxx.ko
From: Johannes Berg <johannes@sipsolutions.net>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
In-Reply-To: <200706291117.35231.toralf.foerster@gmx.de>
References: <200706291117.35231.toralf.foerster@gmx.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lQ7Ytc+ldnGIBTpSVDf9"
Date: Fri, 29 Jun 2007 11:20:26 +0200
Message-Id: <1183108826.4089.30.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lQ7Ytc+ldnGIBTpSVDf9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

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

> CONFIG_LIBERTAS=3Dy
> CONFIG_LIBERTAS_USB=3Dm

looks like a bunch of missing EXPORT_SYMBOL(_GPL?) statements.

johannes

--=-lQ7Ytc+ldnGIBTpSVDf9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGhM7a/ETPhpq3jKURAi4UAJ4uZEGCKFU6ZbsXN3d1fCWZyDQcbACcCC5v
7u3YWE1AtBgp9ZE4mYAFUpY=
=mHgP
-----END PGP SIGNATURE-----

--=-lQ7Ytc+ldnGIBTpSVDf9--

