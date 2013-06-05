Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:48191 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab3FELNO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 07:13:14 -0400
Date: Wed, 5 Jun 2013 13:11:17 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Kalle Valo <kvalo@adurom.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] brcmsmac: disable power-save related functions
Message-ID: <20130605111117.GD1789@ritirata.org> (sfid-20130605_131316_847182_7A0556C8)
References: <1370419185-3977-1-git-send-email-arend@broadcom.com>
 <878v2p3qst.fsf@purkki.adurom.net>
 <874ndd3q20.fsf@purkki.adurom.net>
 <51AEFACD.7000902@broadcom.com>
 <87zjv43jb8.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="UfEAyuTBtIjiZzX6"
In-Reply-To: <87zjv43jb8.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--UfEAyuTBtIjiZzX6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 05, 2013 at 02:09:47PM +0300, Kalle Valo wrote:
> "Arend van Spriel" <arend@broadcom.com> writes:
>=20
> > On 06/05/2013 10:44 AM, Kalle Valo wrote:
> >> Kalle Valo <kvalo@adurom.com> writes:
> >>
> >>> "Arend van Spriel" <arend@broadcom.com> writes:
> >>>
> >>>> This patch fixes a regression introduced by:
> >>>>
> >>>>    commit 6da3b6c48d79da96a36c2632053cf4f53bf48fb2
> >>>>    Author: Hauke Mehrtens <hauke@hauke-m.de>
> >>>>    Date:   Sun Mar 24 01:45:52 2013 +0100
> >>>>
> >>>>        brcmsmac: remove brcms_bss_cfg->associated
> >>>>
> >>>> The regression behaviour is described in:
> >>>>
> >>>> http://www.spinics.net/lists/linux-wireless/msg107474.html
> >>>
> >>> The link is not a very reliable reference, it can die anytime and
> >>> there's no way to know what message it refers to. Stating the message=
 id
> >>> would better. And the best would be to copy the full text to the comm=
it
> >>> log, it's only few lines anyway.
> >>
> >> Johannes gave a handy tip. Gmane has a service which uses message ids:
> >>
> >> http://mid.gmane.org/5197DC4F.7030503@broadcom.com
> >>
> >> If the link or service dies, one can find the email with the message id
> >> visible from the link.
> >>
> >
> > What if gmane dies ;-)
>=20
> You missed my point. If gmane dies you do this:
>=20
> http://lmgtfy.com/?q=3D5197DC4F.7030503%40broadcom.com
>=20
> :D
>=20
> The id above is the real message id from the email, that's why you can
> use it to search from email archives, google and so on.

Would it be too hard to copy the text in the commit message? :-)

Why should somebody jump here and there just to get the description of a bu=
g?
Imho, at least a short description should appear here. In this way also Dav=
id
can immediately figure out what the problem is, without jumping on the web
(imagine many of this in one pull request) :-)


my 2 cents.

Cheers,


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--UfEAyuTBtIjiZzX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRrxzUAAoJEADl0hg6qKeOaEkP/1bcZrVILTT6inlYzMKXzT/e
DVmjDqBdVsaKuBjoBMYKX94zDdmAZ7M7biomWfsQ2NhoJlyb7ADU4euOh71U0bjj
1aR0f2AVqtR43PcVGC5eEqzcxbSNuN3od5ewfTE2mT/CjwXFgZPBVYfLKJmOK+/P
jCCtV2mTB9G7tTzlFYB62DXKklugoRO/hvi2w//vlxwhgIjwHN9BfXx3fHHLbnra
CYpQpSCQ6bqGA9j1YHHkzHJ7UjFhGHlwewU/6WHfmBAzddKpNcDuUacpm69/0Jzq
y1Gq0d28VidPTE4RJMa/8DemoukBrcKuSWSsxr3HMf1IJsyBlTcrL21F32OjQ0cU
aoZzXmCkXFL9aeN59Al76jA4tQMBwrkupY/Ggkhqx9AUXr8sxWrlWkiZhotGkfYM
jlDdqS632KerT/IZKhxd29QzJZdiUG92/f42yEVxIo1f5KY96sD/VL5hqZVs4pcU
AZ33Z42Oqph7w0lNUWc4RRMa5qfDa5crMACBH0WlBiZR8KeQzOfj7zqbNZkLzNCf
e+Tnd3DAoru8Njaro7POQ6OytpAp9Illxp245EDpvbgST4xcSe4ft7RZDjc9RnmR
siEm8m9IFhlcg403YpqMOMOxo07A3LRPwp7meh7H5xXIEjtGvO2JoyOqoaRuCZc/
QSBNiw8T1XBf0CtHdF7g
=v8q6
-----END PGP SIGNATURE-----

--UfEAyuTBtIjiZzX6--
