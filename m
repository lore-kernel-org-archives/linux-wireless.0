Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web4.futuron.fi ([217.149.52.4]:59045 "EHLO web4.futuron.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbZLCGpE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 01:45:04 -0500
Subject: Re: New rtl8187 rfkill support blocks my wlan for good.
From: Antti =?ISO-8859-1?Q?Kaijanm=E4ki?= <antti@kaijanmaki.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4B169608.3010902@lwfinger.net>
References: <1259756709.31590.62.camel@peura.elisa-laajakaista.fi>
	 <4B169608.3010902@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tqOuwql/3hr7z+fU5BBs"
Date: Thu, 03 Dec 2009 08:44:59 +0200
Message-ID: <1259822699.31590.914.camel@peura.elisa-laajakaista.fi>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tqOuwql/3hr7z+fU5BBs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

ke, 2009-12-02 kello 10:30 -0600, Larry Finger kirjoitti:
>=20
> As wireless in Linux approaches the correct behavior with respect to
> killing wireless, there will be some cases like yours. Having the
> radio work no matter the switch position is just plain wrong. I hope
> you understand that.

Of course I understand! :)
Maybe I had some unintentional negative sound in my email. I only wanted
to point out that the current code is not sufficient in my case and I
want to help to get it fixed.


> What laptop do you have?

It's a Toshiba Satellite Pro L300.


> If the RTL8187 built in or externally
> plugged?=20

Built in.


> If built in, is there a WMI driver for it? Do you have it loaded?

I don't know. By WMI you mean Windows Management Instrumentation? I have
WinXP dualboot so the Windows driver probably supports that if present.



  -- Antti

PS.
I contacted Realtek again and this morning I had data sheets for
RTL8187B and RTL8187L chipsets in my inbox, yay!. I didn't have time to
look deeply in to them just yet, but at quick glance the data sheets
didn't talk anything about rfkill. My fear is that the rfkill features
are laptop vendor specific by being implemented using the General
Purpose IO pins, but this speculation is still premature.


--=-tqOuwql/3hr7z+fU5BBs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digitaalisesti allekirjoitettu viestin osa

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAksXXkQACgkQFYSsxt2pELHw3wCeOy6qOMOPatEiS/xxwe9AYfem
VAAAn171H+z9GjFcmqK0RiLb13hFjdsX
=anbc
-----END PGP SIGNATURE-----

--=-tqOuwql/3hr7z+fU5BBs--

