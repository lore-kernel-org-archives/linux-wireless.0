Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36522 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759219Ab1EMNBD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 09:01:03 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Walter Goldens <goldenstranger@yahoo.com>, 596626@bugs.debian.org,
	maximilian attems <max@stro.at>,
	linux-wireless@vger.kernel.org,
	Geoff Simmons <gsimmons@gsimmons.org>
In-Reply-To: <BANLkTim75f2p8wXyfeoz02asRd+Qm9aepA@mail.gmail.com>
References: <13602.31426.qm@web161615.mail.bf1.yahoo.com>
	 <1305262715.4065.436.camel@localhost>
	 <BANLkTim75f2p8wXyfeoz02asRd+Qm9aepA@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-CW1zqG2BSSpZD3IVTId2"
Date: Fri, 13 May 2011 14:00:53 +0100
Message-ID: <1305291653.4065.437.camel@localhost> (sfid-20110513_150120_680331_A013CDDC)
Mime-Version: 1.0
Subject: Re: Bug#596626: [gsimmons@gsimmons.org: Bug#596626: Please support
 Linksys WUSB600N v2 WiFi USB stick]
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CW1zqG2BSSpZD3IVTId2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2011-05-13 at 09:17 +0200, Ivo Van Doorn wrote:
> Hi,
>=20
> >> > As mentioned by Jan, the device contains a RT3572
> >> > chipset.  Its entry
> >> > could moved into the section for known RT35XX devices (i.e.
> >> > "#ifdef
> >> > CONFIG_RT2800USB_RT35XX") as an alternative.
> >> >
> >> > Geoff
> >>
> >> This has already been done: http://git.kernel.org/?p=3Dlinux/kernel/gi=
t/ivd/rt2x00.git;a=3Dcommitdiff;h=3Dce2919c9fffe2aa52f9c3e327176d03764dbf9b=
5
> >
> > That's all very well, but that isn't going to get into a stable release
> > for another 3 months!  Device ID updates that don't require new
> > supporting code should be sent upstream straight away (and cc'd to
> > stable@kernel.org).
>=20
> The patch has been send upstream, it has been in wireless-next-2.6.git
> since April 19...
> http://git.kernel.org/?p=3Dlinux/kernel/git/linville/wireless-next-2.6.gi=
t;a=3Dcommit;h=3Dce2919c9fffe2aa52f9c3e327176d03764dbf9b5
> The patch depends on the RT53xx support patch which was also intented
> for 2.6.40.

What is it, RT35XX or RT53XX?!

> > I've cherry-picked this and the other two updates in rt2800usb that
> > aren't in Linus's tree, but that doesn't help the users of other
> > distributions that would benefit from them.
>=20
> True, but the normal flow for new features and hardware support is that t=
hey
> should be properly merged during the normal merge window. The addition
> of support of RT53xx is not something that should go to stable@kernel.org=
...

I understand that.

Ben.

> Patches from rt2x00.git are quite quickly send from rt2x00.git to upstrea=
m,
> and patches which are not send upstream directly have a reason for not be=
ing
> send at that time (Usually it means that it requires some extra testing).
>=20
> Ivo
>=20

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-CW1zqG2BSSpZD3IVTId2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATc0rf+e/yOyVhhEJAQrfchAAxlXD8qt3G7O5cll1IrsnRR0i2CiaKKza
DyMuFf/b87brY0AyGUCx4yDEXjT1i4vYDJtx6JNxJualYLeGAePYiPDd7OXGTPy9
rQXZYbc+jT7DyglSYuP4uUKHP6fQ+5Fu+XNCAziwSNmNEkar98ash8kzg/vSyii7
rpNE+BjEhrgxBEwj+Y4e+MtDFATJonjLbaBqo1NRHjolOvkr0zXBYPgbPaCXLr17
NPOEfEFabc6leboRq3f23OptfmaQa4BEIXpOgBQVOMJ8LLJ/XgpaqoWIoJHSyT/t
LltrwLCmUQwW0B9HkjicuQfKCx2ENCUcRJWGstXE/NNRdQgBbgd34FquyNHXM+yC
8VfpX7Zf6ec5Ysh07ZVcwh/+v4a4ua2Pb5T4KwhrID6FmZyn8Zcx8WmB9/67Wkud
ipCh/nkqq6e0w3G9wXNQKXZgUA8tlvJfvDC/R2SX5Q1m3MaYRDKP/irYWSBRMyeJ
O8R2YWLIvQoulFrjozsdw2vDa89lygtpKv0GonUwpX3+1NKEvuTl+mmgZNK52fqb
YI7RC3Ers1ubZbaGTo8kLUtOcqEgo0sLY4IULl2Vzto0FnKl5D087gTXazC6tt0t
ZlTGjZSd6MS1BlDaP2MMtamHBpiGyrGnraoeDx60EgZnyyJ0PPK0KWZpPjnpHvvH
arD/MCf1zNc=
=JMIt
-----END PGP SIGNATURE-----

--=-CW1zqG2BSSpZD3IVTId2--
