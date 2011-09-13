Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55850 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933075Ab1IMXls (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 19:41:48 -0400
Subject: RE: Bug#641424: iwlagn: fails to reconnect to WPA2-enterprise
 (Reason: 23)
From: Ben Hutchings <ben@decadent.org.uk>
To: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
Cc: Miguel Martinez <el.quark@gmail.com>,
	"641424@bugs.debian.org" <641424@bugs.debian.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 14 Sep 2011 00:41:26 +0100
In-Reply-To: <C5A7FB31FD9AEA42B600BDC3C74F8E00147CA83E@orsmsx511.amr.corp.intel.com>
References: <20110913111546.6947.55565.reportbug@mark>
	 <1315952954.14749.18.camel@deadeye>
	 <C5A7FB31FD9AEA42B600BDC3C74F8E00147CA83E@orsmsx511.amr.corp.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-9cEg0t8xyNU2iN4bgEB+"
Message-ID: <1315957298.14749.29.camel@deadeye> (sfid-20110914_014151_700052_E38AB0F1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9cEg0t8xyNU2iN4bgEB+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-09-13 at 16:33 -0700, Venkataraman, Meenakshi wrote:
> Hi Miguel,
>=20
> It looks like the AP you're connected to at the University is a Cisco
> AP. I'm not sure what reason code 23 is, will need to research it
> some.

	WLAN_REASON_IEEE8021X_FAILED =3D 23,

> In the meantime, can you do the following so we can see what's going
> on in the iwlwifi driver:
>=20
> 1) Enable debugging for the iwlwifi driver like so:=20
> 	modprobe iwlagn debug=3D0x47fff=20
> You'll need to enable debugging for iwlwifi while building the kernel.
>=20
> 2) A wireless sniffer log would also be useful (not sure you're in a
> position to gather this log).
>=20
> Please send me (only) the log. We can take this to bugzilla as well.
[...]

If you mean bugzilla.kernel.org, that is currently down along with much
of the kernel.org infrastructure.

Ben.

--=20
Ben Hutchings
All extremists should be taken out and shot.

--=-9cEg0t8xyNU2iN4bgEB+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATm/qJ+e/yOyVhhEJAQoFuxAAu2xoVhH4xLDOE2Sgu8viTi7C4bQhB5qV
5WyS7srfnKxP7imIsQ22/cQ7WemDmt1WcYeBUB+dx/S60oTF5PB3dqw4v0jWYPE1
yWUWvkgwqJ/I8jOyX8g7tSioTOM3rTS/JUZHnpTVhlrRau7Ht2S3iUfWE187qQM0
idBd36qzPSy5Nep8kpJcccujADhaMCEOfGjStyFBSb7AcFiEWAooePjKC9j4kBzU
ptlSuEHlKnIvZZdxkqwyhOvEy+tDAiFGd0nu+2q2T6PQ71rwGh47AZr3HOg41KaN
QtiMYG6s5cQPANsujVwY9AHwb9RVQ91j1QUMqsk7CNN6+FXP+ty83w4W/QKWx7Xm
7cTj5vN1x7X2Y6aFnSheOCx6QkzarIL0UKhReEBipd+advWlrLoqNv5TrGzRpQ/U
ARCRU4Bg0VHm1LdBDO2W3VXAxmgNMdXsGKTuINYwgAPDYntoxx4am6A3WbRcE/Ky
6k760HA8D++RthHGFAgliqC+GTIXBXIyur8dNnwoPnqTOBriex66T7HtWsiTJtaS
fs9LQlolzjDUaoDW+S7cAwEELzKXdn/+fNZ6jJyWVvyPai3aLwEn5N5dyUkW4ZDz
ZMMKXQB7T6/ybOnON+CZXmzqfDJOYVztKR1zisyeHdVKoYP9NVrK8RSZ7BHzRIGs
2dNjNeKfRjI=
=PEdB
-----END PGP SIGNATURE-----

--=-9cEg0t8xyNU2iN4bgEB+--
