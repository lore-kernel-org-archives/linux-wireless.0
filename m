Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42260 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761135AbXGKJkm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2007 05:40:42 -0400
Subject: Re: Errors when firmware is missing
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Jon Smirl <jonsmirl@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1183844074.16396.3.camel@xo-13-A4-25.localdomain>
References: <9e4733910707070927l37bdf79cpd1fc672909fb0bb3@mail.gmail.com>
	 <1183826476.3779.42.camel@johannes.berg>
	 <1183844074.16396.3.camel@xo-13-A4-25.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wSpTarQAlfju4Qfxcs8t"
Date: Wed, 11 Jul 2007 00:56:27 +0200
Message-Id: <1184108187.3738.25.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wSpTarQAlfju4Qfxcs8t
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-07-07 at 17:34 -0400, Dan Williams wrote:

> Drivers should be returning -ENOENT (the error from request_firmware()
> when the firmware isn't found) when userspace sets IFF_UP on the device,
> so that userspace has the faintest hope of intelligently informing the
> user.

Makes sense to me. Since it knows which driver is used it could even
tell the user where to get firmware :P

johannes

--=-wSpTarQAlfju4Qfxcs8t
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGlA6b/ETPhpq3jKURAp+bAJ0VYZka7ZfseD38u4JujCz0JbTpuACePpeX
/EXY8I3hMpXB+PqoP7CmMUc=
=PtnJ
-----END PGP SIGNATURE-----

--=-wSpTarQAlfju4Qfxcs8t--

