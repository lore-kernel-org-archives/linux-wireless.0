Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55497 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbYJNVQi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 17:16:38 -0400
Subject: Re: New Regulatory Domain Api.
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Zhu Yi <yi.zhu@intel.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20081014203510.GD3349@tuxdriver.com> (sfid-20081014_223802_063949_1D8CE891)
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com>
	 <20081009154547.GB13349@tesla>
	 <1223608949.2510.1061.camel@debian.sh.intel.com>
	 <43e72e890810100949i78c1d813x1b66c6bc0239ef28@mail.gmail.com>
	 <1223967581.2570.144.camel@debian.sh.intel.com>
	 <43e72e890810140004k6bfa72edsf39acbafcf317fa6@mail.gmail.com>
	 <1223969808.2570.153.camel@debian.sh.intel.com>
	 <43e72e890810140204ne135e72kefe379dd3d26f7bc@mail.gmail.com>
	 <20081014203510.GD3349@tuxdriver.com>
	 (sfid-20081014_223802_063949_1D8CE891)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Cbe+rIb2yjDaa7D5ewoQ"
Date: Tue, 14 Oct 2008 23:15:57 +0200
Message-Id: <1224018957.3027.9.camel@johannes.berg> (sfid-20081014_231645_793079_70F048B4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Cbe+rIb2yjDaa7D5ewoQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-14 at 16:35 -0400, John W. Linville wrote:

> That doesn't sound like quite the correct behavior.  If a channel is
> excluded for regulatory reasons, then I suspect that should govern
> everyone.  But if one card just doesn't support a band, I don't see
> why any other cards should be limited by that.
>=20
> Did I miss something?

Well, the thing is that the iwlwifi drivers pretend to know the
regulatory domain; thus when a single-band card registers the regulatory
domain, it gets set to just a domain with the single band.

johannes

--=-Cbe+rIb2yjDaa7D5ewoQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI9QwJAAoJEKVg1VMiehFYUmkQALd2HXsuUvHbhPy8nQ+L0uia
IDzDEipIf53xrUuKQjNxBTpDclF2cHECT9XaVBTP+KRTNpN5neZn7K75q1UMTqMS
HCD3MOylXiqg7VJcyJQHT9dzQ/qTnoSGR0gj/PJLzv7nxciQmEG6GEqSYCwmF7ep
UGRdQOesW39EjwvJP9gjX9vX5wFZu5tVb/F12lzHEd2h37MyK3+iRk8L5j3+jFJ6
onNyh0ZTFSEBU1oMZHTCDo+VXnU1ZG3VWUjiJoZqTqrhQLGKQm6QdZR6kmt5bZJr
1fzR1FXahEeBv7DlQq0OAxNVOu/DaVewDz142CoRhqY4DeUWfeAfP56rMSZaKYZv
dCMHvbxIZUqcxjuXJ4cDdi7r/Erw7NjM7fylYaHhuGwpcSQsQLP4mEbUrKRemqMN
kB8CqZUet6B2ILYpBoFp+JihDsVYFxy4yoxbv0KFupqtlJfX1WBJYxzX+P/yM6wc
x4HeK67cUIzA5wDGVSZocV/V9UzFQ5JH7dBgw/Gt/n1eRYw4xZE3FfpJ1F9r3Grf
vg47EXK+hCD70EDZ+/9z91MACe9VYirp/1Il3Lf9jAu06/9IcAn+chd6J31nNsVF
WuvTmxSzDwFLS5CEkwkxI9CUQcdxJbUiq72RAp3jsra1XnBXpCtpbDxlhYTl6ro5
vn7fXre8B2SehDqmpNm5
=AfgS
-----END PGP SIGNATURE-----

--=-Cbe+rIb2yjDaa7D5ewoQ--

