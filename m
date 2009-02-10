Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41118 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbZBJPdw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 10:33:52 -0500
Subject: Re: zd1211rw keeps failing
From: Johannes Berg <johannes@sipsolutions.net>
To: Mark Ryden <markryde@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>
In-Reply-To: <dac45060902100545j3d9caf8er2183416f5b5669cc@mail.gmail.com> (sfid-20090210_144559_984950_F1D236FE)
References: <1234262188.4302.0.camel@johannes.local>
	 <dac45060902100545j3d9caf8er2183416f5b5669cc@mail.gmail.com>
	 (sfid-20090210_144559_984950_F1D236FE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mL9Agn23Ywuf+QEH/rzv"
Date: Tue, 10 Feb 2009 16:33:19 +0100
Message-Id: <1234279999.4229.2.camel@johannes.local> (sfid-20090210_163356_581904_70A47984)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mL9Agn23Ywuf+QEH/rzv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-02-10 at 15:45 +0200, Mark Ryden wrote:
> Hello,
>   - Can you please elaborate on under which sequence of operations
> does this occur ? is it the wireless-testing tree? the reason is:
>  I am using the latest git wireless-testing (from today; -rc4 based tree)=
.
> I can associate to an Access Point without errors; and I tried more than =
once.
>=20
> I had tried both when encryption is off in the Access Point and when
> encryption is on in the Access Point.

Odd; I think I might blame it on my hardware. I booted into an older
kernel and it failed similary, though it works just fine with my
unencrypted AP.

> > [ 1819.141519] wlan1: authenticate with AP 8e:b5:9c:32:62:6e
> > [ 1819.340080] wlan1: authenticate with AP 8e:b5:9c:32:62:6e
> > [ 1819.550073] wlan1: authenticate with AP 8e:b5:9c:32:62:6e
> > [ 1819.750061] wlan1: authentication with AP 8e:b5:9c:32:62:6e timed ou=
t

Did I mention that address is completely bogus?

johannes

--=-mL9Agn23Ywuf+QEH/rzv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJkZ47AAoJEKVg1VMiehFYi84P+wfGmoXGLJdSpO+NsFKrnbp/
OxUApb8LThVoWz7Dosc/AScrwAxUjHqHhVBRP2KX46cPZLn+25lw/Oc9sbra60mg
kYAlrIwZzJSvlNrqPdPRxGddO3dLuj5zJWGjoxZinjdKS6ZnWikJtj0YWMSApWcy
HRIqHxhttrhlDwUjjXY2VrsxuU1dRfk6ArY+cPob/WzrDLlnYdDaaoQ56SIsHVJt
QNqqMSoEdkOPgzJdUtHuIwwSCfM2/2inFuZHRTin7pYoEA6vAgX7fzq1hkZe8Zmr
ANF/kmYE3Mp7Qpb/balmCYTz8gfBqm88j4K9kjRwJMexOEQ65+DlDTAqSCZ9Z44z
0sNIVCDOZpNu7lWndwf21g+pMOYxnrHSf4n8UFndV3+6GGnAHVOe3UWvmj61In44
Egwmmw2FU4/BJFRmD1aEPSITovXiFG26043ouqKYA710PbsO4noXYhXDu5v9m7pD
YoAZqa5B7d+a0kUsds6oHEPJBM2WGvW33qNoF5uZ5iuhYXEujSyOCmRXemoMe4Ga
MJjlIgCZ6SxVh6ywbPHUNaqCvP43z/ALeKX2XMEaBcZP+TBvwhEp81BT9IMZq4Uc
wuethQhiCi+Xjd5hC4LH0Od4pKQQYSyAXrBp5patEvhDjcrsFl7boe96iRTaWYS1
Cl5j54kET2GcmL51kMsn
=VlKF
-----END PGP SIGNATURE-----

--=-mL9Agn23Ywuf+QEH/rzv--

