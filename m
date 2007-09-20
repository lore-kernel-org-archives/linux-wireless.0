Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:56073 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621AbXITOK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 10:10:57 -0400
Date: Thu, 20 Sep 2007 10:10:18 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: VT6656 driver source available from VIA
Message-ID: <20070920141006.GH14127@storm.local.network>
References: <20070919193743.GA14127@storm.local.network> <1190297065.18521.61.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aFi3jz1oiPowsTUB"
In-Reply-To: <1190297065.18521.61.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--aFi3jz1oiPowsTUB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 20, 2007 at 04:04:25PM +0200, Johannes Berg wrote:
> On Wed, 2007-09-19 at 15:37 -0400, Forest Bond wrote:
>=20
> > This doesn't sound very GPL to me, however, the twist is in main_usb.c:
>=20
> Not really.
>=20
> > MODULE_LICENSE("GPL");
>=20
> > What do you think?
>=20
> That declaring MODULE_LICENSE in a file that isn't licensed under GPL is
> a violation of the kernel license.

And, assuming that in-kernel support for this chip is desirable, is it bett=
er to
pursue license clarification from VIA, or re-implement using the driver sou=
rce
as a reference?

The reason I ask is that I suspect for this driver to get into the kernel, =
it
will likely see a lot of changes, anyway.  If it's going to be rewritten,
there's little sense in me pushing VIA on the license issue, is there?

I hope I'm not being daft.

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net

--aFi3jz1oiPowsTUB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG8n9KRO4fQQdv5AwRAgmnAJ4/sVb/icVtlzQWA+qd3LxhwzedlgCfWrKm
3/KbR8BTYKGSJCu1VPJegXo=
=HxuX
-----END PGP SIGNATURE-----

--aFi3jz1oiPowsTUB--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
