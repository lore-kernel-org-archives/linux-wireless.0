Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34232 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZDTIo2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 04:44:28 -0400
Subject: Re: rfkill rewrite bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <49EC3366.7080206@tuffmail.co.uk> (sfid-20090420_103348_397116_B4EBC1A4)
References: <49DCA88E.6060400@tuffmail.co.uk>
	 (sfid-20090408_153722_059382_FB44D658) <1239204090.16477.1.camel@johannes.local>
	 <49DCDD2E.80705@tuffmail.co.uk>  <49E38BBC.5010708@tuffmail.co.uk>
	 (sfid-20090413_205524_915082_56358705) <1239741968.4205.1.camel@johannes.local>
	 <49E98C86.2040308@tuffmail.co.uk>
	 (sfid-20090418_101208_980691_83127E2F) <1240043283.5792.0.camel@johannes.local>
	 <49E9A0C7.8040602@tuffmail.co.uk>
	 (sfid-20090418_114338_695917_3CBF9024) <1240057470.4755.7.camel@johannes.local>
	 <49EA10F3.3070309@tuffmail.co.uk>
	 (sfid-20090418_194244_839181_896F358B) <1240077571.25100.3.camel@johannes.local>
	 <49EC3366.7080206@tuffmail.co.uk> (sfid-20090420_103348_397116_B4EBC1A4)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-rj9M7/IrDhF8UdI1MEbS"
Date: Mon, 20 Apr 2009 10:44:24 +0200
Message-Id: <1240217064.28218.0.camel@johannes.local> (sfid-20090420_104430_969584_F8956C24)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rj9M7/IrDhF8UdI1MEbS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-04-20 at 09:33 +0100, Alan Jenkins wrote:

> Ok, revised patch is below. Don't forget the set_sw_state() ->
> set_global_sw_state() change; I didn't include that.

Ok, will do. Thanks for the patch, I'll integrate it into mine.

> Note that there other pending changes to the rfkill code in eeepc-laptop.
>=20
> "[PATCH] eee-laptop: Register as a pci-hotplug device"
> <http://thread.gmane.org/gmane.linux.kernel/791730/focus=3D38724>
>=20
> "[PATCH] eeepc-laptop: Work around rfkill firmware bug"
> <http://thread.gmane.org/gmane.linux.acpi.devel/38424>
>=20
> The second is mine; sorry for not warning about it sooner.  So you/we
> probably need to co-ordinate with the maintainer.  I'd CC linux-acpi,
> because that's where most platform driver changes are submitted.

Ok, thanks for the heads up. Do you think this will generate significant
conflicts?

johannes

--=-rj9M7/IrDhF8UdI1MEbS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ7DXfAAoJEKVg1VMiehFYCaUQAK/3FK5/pIKnaIBrekuQq378
AmlBe+pUO2BZ5GvGthz+ES5miLnT06EnmsMuvJomw81Sgl540OX7j3FrM2E7fOOX
m+9dC3LXGgdWmmI0umdZH2NfexLBAvmR+2/GeoS5tTV32wjDwCiAi1Fz26KIF2rG
HfSMnWF0vfPCz6UQ81QG1wf+x2LUMpD9PJdztjaUnbK65YnVeQcJpgoMCWIKthjI
JmzOa3uixtB9JqvfZojUPqIV3NjAVc91PsA3RGJRHr2nY3NFrFBcLBdT4b85+nHa
6tZKJS5JNqbSwD2vaDGkX3+9zb8nzf8PEHwhMY7b0lI6VpTtB1mYsAxks8MiTJfA
sgHNR5Pdf4xi7urAI1mOoDurwMy10xcSDZHW9KFG+MZjNN8DcrxmjraMEduS853z
c4Z4xx3Yk2w4sVzj7MfLeoi5PvE4bA76bY7fLxE/Frq5nRXP4kfUVvnMVXl94rCY
Lw8N8VsCX5t4QamixF1Zz+YHkSXvK/4iiWni9bu6k2m27yjaG55FL63uieaZKviQ
e2y8Rvwy1vy7nivVpF7zqhjq6+wAfSn2+JUwP+Yb4sVROBGD69kQbqnryYR63mB2
y2X6ms29VAN3sel213AiyzCyLpKzhRowWzYSWsQfqnwbhoiz8xuR9ljNIZgMfZ8m
6XhoV3jwk5SQjEg04JFH
=xjda
-----END PGP SIGNATURE-----

--=-rj9M7/IrDhF8UdI1MEbS--

