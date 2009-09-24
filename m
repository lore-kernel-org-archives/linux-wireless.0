Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44243 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbZIXPFL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 11:05:11 -0400
Subject: Re: rfkill hard state after booting
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Norbert Preining <preining@logic.at>,
	linux-wireless@vger.kernel.org, Mattia Dongili <malattia@linux.it>,
	"Almer S. Tigelaar" <almer@gnome.org>,
	Matthias Welwarsky <matze@welwarsky.de>
In-Reply-To: <4ABB89B2.8070302@tuffmail.co.uk>
References: <20090924130231.GU21590@gamma.logic.tuwien.ac.at>
	 <1253801252.3868.108.camel@johannes.local>
	 <4ABB89B2.8070302@tuffmail.co.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-cr/B34V6AJNy+TPG0n1T"
Date: Thu, 24 Sep 2009 17:05:13 +0200
Message-Id: <1253804713.3868.168.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cr/B34V6AJNy+TPG0n1T
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-24 at 16:01 +0100, Alan Jenkins wrote:

> I think it's pretty clear it's in the sony code.  It doesn't call
> set_hw_state() during init.  I.e. (completely untested):

Agree, looking at the code this seems reasonable.

Although maybe it should just call sony_nc_rfkill_update() after
registering all of them?

johannes

--=-cr/B34V6AJNy+TPG0n1T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKu4qmAAoJEODzc/N7+QmaofoQAI3Apnstd3KSiZxDaXnSfBJq
/c93fhb5jW+lPI4UK+25AITlqN6IvCDtrr39VX0vP3n6UKYJJfDnHht2DK3O97lU
yCd5hkGHi0zIjYQNqMgpk1B5ut0GDCkeKSBl0/+ggMfI57oskRs+FCPlaUTdA/RE
cZ1TfpwSpcttaSDTM1xfzW009OlpjkXCj79klMcuWQzolrFC9QrpFf4DeXRvPQct
T2KaSeeep3abI7/9A1zJHV9XL/9ks/jvLER4MVJpMVZIuXPGsJTINUz0WbXMyfnc
tMj4JMBwcrBFXS8coCpqkhFPR74b367VQv5245BIFxtR6++pEt+Si7HrRn5VQv+1
3pVGPCclqZEv2+/e4USr3cy0VdVjT7oHh34Eb+HzNf6ho95/L9PMa30VSrLGmX61
eolrf2X5+97TSk8IPysirZGdXo4PbeyHvyDn0YppOseplVS0sPdqB2ossruilHta
c9q7GFOD3mj5lH/V0yD6Zc0mysMwWFn4XzywEWwVaxnrVEQ5GaKiA5pt/RYng8je
CSFimTI1hWn06bU5QYM0o2Ky08C1lyNwiVsTlw3dgZAJp8g8CcJwMzf8m/LgL4gC
vOyyNVaqZxdbx8ZJCu4vT1iEdTiidpPizcljjoYc9oWtTxVKc2pzeEluDFk6QW+/
JWrHt/S9OQkiz6tNJEPi
=8FxA
-----END PGP SIGNATURE-----

--=-cr/B34V6AJNy+TPG0n1T--

