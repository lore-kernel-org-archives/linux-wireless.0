Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53876 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbYFSPiy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 11:38:54 -0400
Subject: Re: [PATCH] libertas: make mesh code configurable
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
In-Reply-To: <200806191704.10297.hs4233@mail.mn-solutions.de> (sfid-20080619_170429_512985_CDD100EA)
References: <200806191704.10297.hs4233@mail.mn-solutions.de>
	 (sfid-20080619_170429_512985_CDD100EA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rXFJ53k/axhWap4pExBx"
Date: Thu, 19 Jun 2008 17:38:05 +0200
Message-Id: <1213889885.8967.31.camel@johannes.berg> (sfid-20080619_173857_297349_19C78273)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rXFJ53k/axhWap4pExBx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-06-19 at 17:04 +0200, Holger Schurig wrote:
>=20
> --- wireless-testing.orig/drivers/net/wireless/libertas/persistcfg.c
> +++ wireless-testing/drivers/net/wireless/libertas/persistcfg.c
> @@ -1,3 +1,4 @@
> +#ifdef CONFIG_LIBERTAS_MESH
>  #include <linux/moduleparam.h>
>  #include <linux/delay.h>
>  #include <linux/etherdevice.h>
> @@ -451,3 +452,4 @@
>         sysfs_remove_group(&(dev->dev.kobj), &boot_opts_group);
>         sysfs_remove_group(&(dev->dev.kobj), &mesh_ie_group);
>  }
> +#endif

you know you can build files depending on Kconfig symbols, right? :)

johannes

--=-rXFJ53k/axhWap4pExBx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWn1YAAoJEKVg1VMiehFYQXQP/jyPffwXLjrEGDFXJEtii43/
TQhM1i/lyuYpSi9aQmKzCp5bS8h5mtw5KxQysxkQfiOTRyAq0jWAliXxFiwFoMx+
F12YSB7iydl2qs8JX9m6XFzj4C2FwunUzExZSIz/b6NA4Fcvy+HLis8ybqnKIgzG
5UgljHmisFknAonF+MRLxq9vDBVWabz5wgYOkUF7nqL+Qx9wUMKNtQ0dAWMMTUh7
XvH8jeB2hn5RmvJY33Ls1VabDxNphgQ+jG9NFbTPFIt6DjUI7xQW+dc38HreeE4q
G2QhY68LDEkIBd8PUf7xlHV2fxcEO0S4bnFAL6C6y1Dgk3lfdMLXOQS+wXJos8qL
BOB5v3F+Q0jFn1J0SrFD6YYx42Z1qBH/fbJsBo0NiyXgOpzqZyCcNKst1TBonXxs
zh0g2JGtSuYPhfutev/+PRJt+K9B4dICwyIarHMiEEMKml0K9h/HQlZ5VPcyxciX
hI72Bp/594Zm4/UI3d4mZCf8dsyih88esd+kWy+gd/HeHt2jtJTWGUpz+VD01Yco
E3DisvDQHXg2JEJ/URIuA8BNZT5Ssr+2iBgi7LRy6wsyiN9X0qq3O0R3ucDGeFaC
GpNIrsQUSVwMYzvcZUhNHDeWswl33o1A6R7D1bIprZ5LD76fcRfGoMIW4YaN+IvK
U0FHa0QFlHhM1S+SHE8B
=7OWX
-----END PGP SIGNATURE-----

--=-rXFJ53k/axhWap4pExBx--

