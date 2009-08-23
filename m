Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46622 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916AbZHWJNw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Aug 2009 05:13:52 -0400
Subject: Re: Abour linux driver supports BCM4325
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: feng tian <feng.of.tian@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <4A90B086.1020503@lwfinger.net>
References: <f42a38140908202319y5c352aa3s37fec67e5cb8d7a3@mail.gmail.com>
	 <4A8E8F59.9050706@lwfinger.net>	 <1250858409.5137.2.camel@johannes.local>
	 <f42a38140908212242h1ce0339fw1243dbacf54000ab@mail.gmail.com>
	 <4A90005B.3030101@lwfinger.net> <1250964823.23605.22.camel@johannes.local>
	 <f42a38140908221927qabc3f25t60f348f7c4a446c9@mail.gmail.com>
	 <4A90B086.1020503@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-nf7o4IE0DgcFRUN2rG6o"
Date: Sun, 23 Aug 2009 11:13:50 +0200
Message-Id: <1251018830.23605.32.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nf7o4IE0DgcFRUN2rG6o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-08-22 at 21:59 -0500, Larry Finger wrote:
> feng tian wrote:
> > Thank you for the information.
> > I get your point. As for the radio and phy driver, I think it's  some
> > command based configurations for the chip via SDIO. And that I can
> > refer to the BCM 43xx PCI driver codes.
> > Wonder if it's feasible. Needs your comments.
> > Thanks
>=20
> The first step is to be able to read/write the various registers via
> SDIO. That will be similar to the PCI operations. The next step is
> knowing what to read/write and when. We are still working that out for
> PCI. It is not trivial. See the recent postings of patches for the LP
> pHY in the linux-wireless mailing list. These are _NOT_ complete.

Right.

You have two completely orthogonal problems:

 1) changing b43 so it knows how to talk not just to SSB/PCI/PCMCIA
    chips but also SDIO chips
 2) changing b43 so it knows how to talk to your specific radio/PHY
    chip, and LP PHY

However, 1) is being solved for you by somebody on the IRC channel with
whom Michael is in contact, and 2) is (hopefully) being solved for you
by Larry and Gabor.

Thus, the best thing you can do is familiarise yourself with the
existing efforts and eventually try to put them together and test with
your chip.

johannes

--=-nf7o4IE0DgcFRUN2rG6o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKkQhLAAoJEODzc/N7+Qma08AQAIexJywflkGxdDKBqjLiclbC
AUGuUobW1csWDf77FdVKMmYLJ7iRTSO3hUGxbGislYVnm/g9b5md0RUiB0E46HE7
zw3VxqBYaqIAbHwxVN4GQ8Hi6eVTETq2g/MFhRsHvG+3utTTdsNI1O9YwPYdQhGL
3DrS8CF4APgP9ts6vJcv6N/G7S+uqeylt+3OqWTiXkfZiNf0Vm2HKJXUS4HSBTkn
Oz5qat2MCQKDf5BJ0+XSyltcltmm4FunZWQQ7EKCde5gbOH6JPem007TBlBkxy+6
yMjrEpiRqYTvVYgYR0DSfbQ5ER/qVnQHiybknCLC3x/ziJUrnb9/zKxnZ/x3Zg7P
gBDCf2B6UBYuzaVq4hbQ3PReu7upBVAUO8F8rmJ3eICuvDMD0GYmL/Bt47HkUAa7
jH9Fa/29WXiBY4uk49LHVWISB7pwT62Rqw0dyg1yL7lxtx4w92dyIjbzSZ8/nc3N
AYnrJI2434LVOLwZLGqr3uonXSo94KGZ8yeBZgIwkWmk/ovxa8rlWBDNdWN2BNhW
F+8TQmPNzNhgYGFftqbPJtlPTeL3e/XV7LRkJw8SoSQyLZD3q+fzRG8Apb9GBmD3
4izrYBp+9JhMow6jXmKWqr/jAhb9UUehaQTqB2lMb3ZWUfCOrt1paEi1rfPLpLC3
0FfiZ7fJ1wnt0481Kw7q
=Bsl8
-----END PGP SIGNATURE-----

--=-nf7o4IE0DgcFRUN2rG6o--

