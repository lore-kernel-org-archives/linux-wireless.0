Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53234 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbYENNWo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2008 09:22:44 -0400
Subject: Re: First patch to mrv8k driver?
From: Johannes Berg <johannes@sipsolutions.net>
To: Markus Becker <mab@comnets.uni-bremen.de>
Cc: Pavel Roskin <proski@gnu.org>, John Daiker <daikerjohn@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0805141506000.24384@bugs.comnets.uni-bremen.de> (sfid-20080514_150818_666387_341BD5DB)
References: <482A3961.2010906@gmail.com> <1210739857.2721.51.camel@rd>
	 <Pine.LNX.4.64.0805141506000.24384@bugs.comnets.uni-bremen.de>
	 (sfid-20080514_150818_666387_341BD5DB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iCpCFhfz8RgN7iGxb+4C"
Date: Wed, 14 May 2008 15:21:50 +0200
Message-Id: <1210771310.4279.87.camel@johannes.berg> (sfid-20080514_152248_205899_7568CE9F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-iCpCFhfz8RgN7iGxb+4C
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-05-14 at 15:08 +0200, Markus Becker wrote:
> On Wed, 14 May 2008, Pavel Roskin wrote:
>=20
> > On Tue, 2008-05-13 at 17:59 -0700, John Daiker wrote:
> >> Hey All,
> >>
> >> My first patch for the mrv8k driver.  My machine locks up when I try t=
o
> >> load a firmware, so I'm not sure if this patch helps anybody or not.
> >
> > I don't see any changes for mrv_reg_read32() claimed in the description=
.
>=20
> He is checking the return value to 0x5 instead of 5.

You realise, of course, that those are the same number?

johannes

--=-iCpCFhfz8RgN7iGxb+4C
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCrnbaVg1VMiehFYAQLl7w//dUU8aRK6GC6A1eomY1wVt308JI37QO/V
pvRvUjKLBmcvAJe7oAxQk62pVPyWX1QEKACRPyJqJ/HRyzZuvAYi8xMqQStLM932
Vthg6sdbkCPv7j42DoXJqFqnq3DRq8QGl8cX455m+YUgh67uiZnGMO0m4rmhcfUk
0oQW3uKn/5GHcftHMpkd07A9k5yTTw340ybjXoXMB9XEa/7yNPNfYJMYJwKADrSV
E4qkUKj1wBBV0uNf/Vte5zc1hM2mC/tcLM2FODYPltn0uSoIl2SRaRJtcvyFA5MZ
HV+YBVngtEwnj+Xkbo0YREUudLJSF3sKKv0jdpAP3o7PTdYZCF0ozB6cwiIGPtYl
mxhnNwKHUfviiy+OO+ppp8AF3Z1DD3cOngUWs24tnVntIgGaypVo+XqWXUD3dKwx
zFLeduNfPfIdjpf3GfXQy7z4dLFt9NJKKIE/mbDZM0F62Qx2kV581d4yGmDzH3k0
w7LZiFzO7XtMXYktW3bMGQtlj0+QPTTIQK2TOXMmAfagm6R2KTp3q5GgynOShcb2
aNMgEhOFSPku1o1bgFcmvPCxEerbWGhmGv3E/r/uLnZAEopCbwMAYK2+SAYhzxZW
jzIXi0zSmr9TMrlVet8fKrIOehB1yO9ha4Kz9jdJDe/m1YIH8bd+xl8Xa2bX7xLG
/EHvGUXw7os=
=fHMS
-----END PGP SIGNATURE-----

--=-iCpCFhfz8RgN7iGxb+4C--

