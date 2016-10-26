Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s2.neomailbox.net ([5.148.176.60]:2734 "EHLO s2.neomailbox.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755456AbcJZOLJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 10:11:09 -0400
Date: Wed, 26 Oct 2016 22:10:16 +0800
From: Antonio Quartulli <a@unstable.cc>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
        sw@simonwunderlich.de, Antonio Quartulli <antonio@open-mesh.com>
Subject: Re: [NOT FOR MERGE] ath9k: work around key cache corruption
Message-ID: <20161026141016.GB26376@prodigo.lan> (sfid-20161026_161113_561652_5894C956)
References: <20161018083552.28592-1-a@unstable.cc>
 <87lgxbxl2d.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jq0ap7NbKX2Kqbes"
In-Reply-To: <87lgxbxl2d.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--jq0ap7NbKX2Kqbes
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 26, 2016 at 05:05:14PM +0300, Kalle Valo wrote:
> Antonio Quartulli <a@unstable.cc> writes:
>=20
> > From: Antonio Quartulli <antonio@open-mesh.com>
> >
> > This patch was crafted long time ago to work around a key cache
> > corruption problem on ath9k chipsets.
> >
> > The workaround consists in periodically triggering a worker that
> > uploads all the keys to the HW cache. The worker is triggered also
> > when the vif detects 21 undecryptable packets.
> >
> >
> > This patch is based on top compat-wireless-2015-10-26.
> >
> >
> > I was asked to release this code to the public and, since it is
> > GPL, I am now doing it.
>=20
> GPL? AFAICS ath9k is under ISC. I'm not sure what you mean with the
> sentence above, but it's possible to interpret it so that this patch is
> not under ISC license, which is problematic.

Honestly, my sentence was just a way to say "it makes sense to release this
patch to the public".

If it needs to be ISC in order to be merged, then it can be released under =
ISC.

I don't want to enter a legal case :) I just to make the patch public

Cheers,

--=20
Antonio Quartulli

--jq0ap7NbKX2Kqbes
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIbBAEBCAAGBQJYELlFAAoJEJ6F1zG2JyOsJL0P+L4lHl/Ie26dckyn5ow6Cjxo
BW9JLvBP0E6DbUkrz3OoCP9YZifbRZ82YM6V0DTH/OPxlgLV6v4sCs0RpUOS7owf
DPITig28p32oKdLVWzClFlL1NCe+Z7mdkeqxdDYIsHXx/xjB9/JedPK+mhnZYOoZ
0XGHJ+gdjP4nAepnyOEYWMkgcq6FnBrm87eYGy5wXAqyRNHcibgWEKlWkzsxoSAm
ryqP55hixHxtYI76+vVxkQTHYo2VNS5Gv19Zz2zBxrlqCXHaect62n5b1M6Fex7U
+aiyWFMc4vgCv7yAjPWI2YPq5z+AQhz9fvTtqVqa1Mt2dQLCqeReCxtyZDxRFwq3
JGDAZmSaiqBQuiYfxhe5w1KBaWTFBI60uJcN6fmXgb35b/0qDriN90NqrMg680d1
aws6Z0Aw8rdelQuJzuRbY2kKus/it3rWNppznDEswjN4b3DvcGLY7HunGsgj67jt
b61g2ts5tHjvavy3lbmQ7efkQxGLIge4Nr0q9ptPaoitZ3FzauO4aL+GPCQ+ZKOm
HnWOH+dtm3MlviY0IWQeoWQtod5mUkX2aHTIwa2oYBt9TxhdCQ6G5HwCLvWzfvtc
hXg9qPG8DvqHqYwtWvqt+TmjIibwX49uyaezpASGNp/36F/YtHn6Y02AEbPFvzP7
VSFqh8P7TDjnmufGCow=
=GWvf
-----END PGP SIGNATURE-----

--jq0ap7NbKX2Kqbes--
