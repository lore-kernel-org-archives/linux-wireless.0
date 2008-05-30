Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46170 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbYE3OlD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 10:41:03 -0400
Subject: Re: suspend vs. b43
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Grundmann <mgrundmann@htl-leonding.ac.at>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200805301631.56899.mgrundmann@htl-leonding.ac.at> (sfid-20080530_163811_438107_A856D3A6)
References: <1212150713.4117.2.camel@johannes.berg>
	 <200805301631.56899.mgrundmann@htl-leonding.ac.at>
	 (sfid-20080530_163811_438107_A856D3A6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eM+p+oT7BdmH4sxzhWOM"
Date: Fri, 30 May 2008 16:40:38 +0200
Message-Id: <1212158438.4117.6.camel@johannes.berg> (sfid-20080530_164106_891193_F9741D8B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eM+p+oT7BdmH4sxzhWOM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-05-30 at 16:31 +0200, Michael Grundmann wrote:
> I can reproduce this too on my HP6715s=20
> (b43-phy2: Broadcom 4311 WLAN found
> b43-phy2 debug: Found PHY: Analog 4, Type 2, Revision 9
> b43-phy2 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2)
> it hangs while hibernating with tuxonice.

Just a note: this might seem like a different on first sight, but since
hibernation will actually call resume before powerdown it might be the
same.

johannes

--=-eM+p+oT7BdmH4sxzhWOM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEAR5aVg1VMiehFYAQLV5RAAwoQXaBELUf6LiYShB4ATtjr9sqEPjaH5
6MGyB/2kEEoqxLri2E7gm/wxzBdndVtADfaFa17WeJ1qwG1I2J/9f+2D5b9pbKYD
F1Z9/CsajZG6wmaMTm57KdSXE20Tf0FoXY/Aa42+xXi5rd9TaUI5mqbhFxa4pgdj
goml2OCXO9MftU++FPMAvHG7qi4uDeZVQSCEG0yzJZ4Q6pBr2QnvouGwEFwWSRSI
e+iJt8i3CQshd4pZhMrs419DruPy4p8NUQ8vujx2UkJ+r23X+s5560kJMd4QOl1n
xCK/IfcxPoqeCQtNMEcn3ZJ/bjLYrdHMyK0iiji7/sLEotlR5pea3PzqXPrmK/+K
wGqdADcgR34V39giWLMqApZvbihY1Ef2DxvzZyCMplRVVj0F609GSNQrUIh2LuCz
OmwEhts0TM5iRxE/3zx0I5zMKEdN/TdDq2MAtopJQBlhZb7vyB1v/i32IZm5roHo
K7R3d+1PO5frKxBHq7ehvw55VNUTJtCtpyR6aqZRADEHATFIN+tT6hwJfffp0uFi
ZrLZJye3wuY+1jXc4dFXqzswH3EVIYPRphMeZtH1hnf1qtxyqhyMfw0ppvkgGwgW
vVKslJ1et18KuHsUkJiyY+NoULeYMm/Sww9u3oh5r+fxB4MklBIduDWpDsXdJOUt
SvC5lOFGKMc=
=hxG7
-----END PGP SIGNATURE-----

--=-eM+p+oT7BdmH4sxzhWOM--

