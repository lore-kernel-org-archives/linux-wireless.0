Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fep17.mx.upcmail.net ([62.179.121.37]:46181 "EHLO
	fep17.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932775Ab2K1WLp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 17:11:45 -0500
Message-ID: <50B68C25.8040105@think.ch> (sfid-20121128_231202_368107_729EAEFC)
Date: Wed, 28 Nov 2012 23:11:49 +0100
From: Erich Titl <erich.titl@think.ch>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: regulatory domain settings overwritten
References: <50B470CE.8070402@think.ch> <CAGRGNgVT-Yru2ti9CWgwS5H2cfW=RTeL144zsdAmSRCAsLwOsg@mail.gmail.com> <50B4B7B6.7020205@think.ch> <CAGRGNgXz9L+DBuxii7p+r0m2SEa0Xy1JgDZqGf2-8xWuHBYdfQ@mail.gmail.com> <50B5B915.2030706@think.ch> <CAGRGNgUzQk=m1vzp2+LbosDaddGnhwJC2P0cJHTW57EemNus+w@mail.gmail.com> <50B62317.1090001@think.ch> <CAGRGNgUZSmfJ91QtQOCmAn_3R8dsUerM6NwKPXwig_L1YsnZuw@mail.gmail.com>
In-Reply-To: <CAGRGNgUZSmfJ91QtQOCmAn_3R8dsUerM6NwKPXwig_L1YsnZuw@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms090703050100040406020402"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dies ist eine kryptografisch unterzeichnete Nachricht im MIME-Format.

--------------ms090703050100040406020402
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Julian

on 28.11.2012 23:01, Julian Calaby wrote:
> Hi Erich,
>=20
> The rule for dealing with invalid or default regulatory data in
> Atheros cards is to use the US region.
>=20
> This is specified in Atheros' documentation for the EEPROM format.
>=20
> The code is working as designed, to the specification for the chipset
> and as close as we can be certain to compliance with all applicable
> laws.
>=20
> The fact that your cards are using the defaults indicates that
> somewhere between the factory and your hands someone isn't testing the
> cards to verify them against a set of regulatory rules.
>=20
> As far as I'm concerned, this matter is closed. The issue has been
> explained to you repeatedly and in detail. Arguing with me won't
> change the specification, won't change the code, and won't change the
> fact that the device and driver are working exactly as they are
> supposed to.

Of course it is and I don't argue that

Thanks

Erich




--------------ms090703050100040406020402
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Kryptografische Unterschrift

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
--------------ms090703050100040406020402--
