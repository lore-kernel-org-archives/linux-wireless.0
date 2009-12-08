Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from attila.bofh.it ([85.94.204.146]:51537 "EHLO attila.bofh.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755440AbZLHPbp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 10:31:45 -0500
Date: Tue, 8 Dec 2009 16:24:23 +0100
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org, linux-hotplug@vger.kernel.org
Subject: Re: wireless device and udev
Message-ID: <20091208152423.GB21112@bongo.bofh.it>
References: <20091207172616.7470ed2b@nehalam> <20091208142940.GB15172@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
In-Reply-To: <20091208142940.GB15172@tuxdriver.com>
From: md@Linux.IT (Marco d'Itri)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Dec 08, "John W. Linville" <linville@tuxdriver.com> wrote:

> What does udev do for bridge, bond, or vlan devices?  Don't those
> share MAC addresses with the underlying physical device?
They are blacklisted (by the DRIVERS=3D=3D"?*" check) so they do not get
persistent names.

--=20
ciao,
Marco

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkseb6cACgkQFGfw2OHuP7GowQCgibq5Xh+bc10q0C2KlNT3oV3O
CswAoKYTSAo6XfCAbTzSFO9ko+8FWoTj
=urKP
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
