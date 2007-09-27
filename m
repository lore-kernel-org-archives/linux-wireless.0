Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56059 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbXI0Rql (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 13:46:41 -0400
Subject: Re: [PATCH] libertas: fix link errors (bz# 9077)
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rjwysocki@sisk.pl, Dan Williams <dcbw@redhat.com>
In-Reply-To: <20070927101742.44146651.randy.dunlap@oracle.com>
References: <20070927101742.44146651.randy.dunlap@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gL9cKu9teEBT2ySzGYp9"
Date: Thu, 27 Sep 2007 19:47:43 +0200
Message-Id: <1190915263.5021.8.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gL9cKu9teEBT2ySzGYp9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-09-27 at 10:17 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> Fix missing symbols in libertas USB driver when it is modular and rest
> of libertas is built-in.

Ohhh. Thanks Randy, I stared at this problem for a while and never
noticed that it said _USB there.

> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/net/wireless/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> --- linux-2.6.23-rc8.orig/drivers/net/wireless/Makefile
> +++ linux-2.6.23-rc8/drivers/net/wireless/Makefile
> @@ -43,7 +43,7 @@ obj-$(CONFIG_PCMCIA_RAYCS)	+=3D ray_cs.o
>  obj-$(CONFIG_PCMCIA_WL3501)	+=3D wl3501_cs.o
> =20
>  obj-$(CONFIG_USB_ZD1201)	+=3D zd1201.o
> -obj-$(CONFIG_LIBERTAS_USB)     +=3D libertas/
> +obj-$(CONFIG_LIBERTAS)		+=3D libertas/
> =20
>  rtl8187-objs		:=3D rtl8187_dev.o rtl8187_rtl8225.o
>  obj-$(CONFIG_RTL8187)	+=3D rtl8187.o
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=-gL9cKu9teEBT2ySzGYp9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG++y//ETPhpq3jKURAvFyAJ9u4UciheAm7O82/cTxO08czRhHFQCfTT6/
4Qsz6it51XCKNbW9o7rdLBk=
=o4vh
-----END PGP SIGNATURE-----

--=-gL9cKu9teEBT2ySzGYp9--

