Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36095 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760481AbZCYPta (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 11:49:30 -0400
Subject: Re: wireless powersaving (in NM?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>,
	Matthew Garrett <mjg@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1237995072.18896.9.camel@localhost.localdomain>
References: <1237891149.4320.73.camel@johannes.local>
	 <1237910398.9082.7.camel@localhost.localdomain>
	 <1237979070.4320.156.camel@johannes.local>
	 <1237995072.18896.9.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sWDTX6r1q4DqQmoinv+6"
Date: Wed, 25 Mar 2009 16:48:57 +0100
Message-Id: <1237996137.4320.161.camel@johannes.local> (sfid-20090325_164934_525039_501ECA9C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sWDTX6r1q4DqQmoinv+6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-03-25 at 11:31 -0400, Dan Williams wrote:

> Yeah, sounds OK.  Just to be clear, problems with this code will appear
> on a *per-AP* basis, not a per-card basis, right?  ie there are some
> stupid APs that won't work with it, but it won't be the case that a
> chipset will be broken for all APs, right?

Right. If a particular chipset doesn't properly supported PS then we
shouldn't actually support it at all -- but we cannot know if the AP is
broken.

johannes

--=-sWDTX6r1q4DqQmoinv+6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJylJmAAoJEKVg1VMiehFYdoMQAJU5YcaMUTA+2r6s2mp2PEBj
fmPVOgbQupC3mn/GUI5+gCG8eKyPU36ZHujce4hs6zPHGUVF0WS8fuMMvnIZ4aZt
HqcxD5IUyt7XB/4ow7bPdUMciWQsrAFdArjc/HGZ0YG2v0Q2bZhsjm/2YyOgJgUe
ifo2a3++tdWr1UI3MxE2uCB2XE6q5c4D2wMblNIDTn98SSOezkjH/DudCSLwknZ3
ERVTVaaOxFUqDEWZeCGa/DDPUTPQDdqOkKEJpp5Q02y3In2Oli5JAXsDADU7uxB9
1Tw81M/5Qq9BUexcIVSw2yUl2aIc1bbx2RP9+MerVwk2+LAM+mVn5drHeLS7cYgh
pw8oqKmy7vOkxHmAW8jBneRCeXN2OT5kWiRJoRANI5zLV5QIQi2mGBREDK+2aowA
RyXAHUthuTBNuBitph4A3jhu3hY11q5dfVmC1cEHlkRWKlB1D8XQcn1Iq/926Eox
SpA8Tqfq0eKSDXtgxaMeq9nCet8iiPzn+11Mwccq/KhRMFI4CNPbi0zpRG73u8I9
8ug0vZY78C04fcbR4NgfJ89dhBov1Y33rkcjoQYudPJiSWxuk2xfTAFtwnqfimQa
Z1kRm30QeKbJ/88gzjR3GmdLefBk1TfpFHTMYI9+VXdU6V6HrYaE/r3uWZ+Z7Zl5
lVu/xvja5T1TvlNqPqba
=QE4i
-----END PGP SIGNATURE-----

--=-sWDTX6r1q4DqQmoinv+6--

