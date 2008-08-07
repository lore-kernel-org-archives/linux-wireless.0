Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41394 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbYHGGdc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 02:33:32 -0400
Subject: Re: [PATCH] mac80211: split out aggregation code
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240808061538l1e1d7a70x11ef7143ec9d2ea5@mail.gmail.com> (sfid-20080807_003839_357846_1538C3E0)
References: <1218051603.23048.63.camel@johannes.berg>
	 <1ba2fa240808061538l1e1d7a70x11ef7143ec9d2ea5@mail.gmail.com>
	 (sfid-20080807_003839_357846_1538C3E0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0ab8d5E7EexQmrP7H+F4"
Date: Thu, 07 Aug 2008 08:32:55 +0200
Message-Id: <1218090775.23048.84.camel@johannes.berg> (sfid-20080807_083336_262339_4E68958E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0ab8d5E7EexQmrP7H+F4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-08-07 at 01:38 +0300, Tomas Winkler wrote:
> On Wed, Aug 6, 2008 at 10:40 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > It's more manageable that way. Also move some constants to
> > include/linux/ieee80211.h.
>=20
> I'm not sure this is good point of time to do that. Aggregation is not
> working on 2.6.27 and we want to fix it there.
> Splitting now will just complicate the effort.

Ok, true, I just had this around so figured I'd send it out.

> > + * Copyright 2008       Ron Rindjunsky <ron.rindjunsky@intel.com>

> You would probably want to add this one as the major copyright.

Yeah, but seeing he wasn't on the file where I took the code from I
didn't want to add it. You guys should post a patch adding it to the
files where you have contributed.

johannes

--=-0ab8d5E7EexQmrP7H+F4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImpcSAAoJEKVg1VMiehFY0AgP/Aki/ajN8TnQKvYzhEDstCKm
ZGVnyfhVMXcVGhsD+cBwwXkTmgiWJ2WALMvjppcT4EHUsOgC46NaoofxIb+n+Fv1
aV3BOGMEIpmwQsL1BFXflQ5Xxg77sgA4jM03MjkperS4f/vDYbH1ZWc/kd4uqYVX
hHaYqjqedjOQ9Y+iKmthmosFzoylEZRXVpaob+HhHwh5f/jmE+lZ+qEHeXQGpeyq
wGrzk38hWjbjsfPmfcVu0MOFHHJ1wQa3i5V+A7LKXZ6KCv1pJqfSMQklVtEShAoD
MrbMXQMDk52UaL3hmmJa/ttxXUAZeJVO1IcA9IAvSQxfziHL0vWKZWmeYRUnFMG1
tkh6IRUPBvbsZcPyfv0sWbvPi6jwc3QEqzCguG5Dg2t/efVbvFF2tdJlzrK+1CzH
L6sCnPso3a5fQ9W6grghDGFkrHEw+4dKLkYTNp4K2Ve55SgU8suhBx1adcFpnFEX
fyQSQ+xDSJqiCp0RTuUYWpUhIaZ4c50rDkNX4rQZDoWyDt5DlzBRNS8nKzC4+M5Q
UXxZfKghGj17wT8cgaomoxdZbTpt3GLmOwi3Q6QhXojaV9aP9ROD4+T3P5kp4bsm
lyK7nxoTed8rApjuBmlRWExzhd+Uvozt25J26NncBQPCLNhJXJ+W4FPeXMFgZUEU
zmpUoY7r+NSfiy2+8Ady
=gI++
-----END PGP SIGNATURE-----

--=-0ab8d5E7EexQmrP7H+F4--

