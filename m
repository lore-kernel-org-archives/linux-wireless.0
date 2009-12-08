Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37697 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201AbZLHT3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 14:29:40 -0500
Subject: Re: wireless device and udev
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org, linux-hotplug@vger.kernel.org
In-Reply-To: <20091208185222.GA16303@tuxdriver.com>
References: <20091207172616.7470ed2b@nehalam>
	 <20091208142940.GB15172@tuxdriver.com> <20091208104336.3d5a7fb4@nehalam>
	 <20091208185222.GA16303@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-p6jEQ7MvDg3Czo5URP7I"
Date: Tue, 08 Dec 2009 20:29:11 +0100
Message-ID: <1260300551.32227.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-p6jEQ7MvDg3Czo5URP7I
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-08 at 13:52 -0500, John W. Linville wrote:

> So, probably we need to map from the wlanX name to the phyY name,
> then determine whether or not this is the first wlanX for phyY.
> If not, then the name should be left alone.
>=20
> Now, how do we figure out how many wlanX's belong to phyY?

And what's the "first" one? :)

ls /sys/class/net/wlan0/device/net/

will give you the list of interface associated with this device.

johannes

--=-p6jEQ7MvDg3Czo5URP7I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLHqkDAAoJEODzc/N7+QmaI4EQAMVMb01v8sbI/pkeTlgDpnqA
x0xrX32My+/6K46saNazBp+cMsbJogOazOyXYNKKuVdZ6RpKSJGqaCLbr5zjdzB4
jYq5XQKYj/u3VZ5u562YudPK01yJrSXb0DDMHcv4bd6IzEWwgUCRaG5YtyN+PuDb
LvaXeuMQYdLCM28xncyL8LAH1UbSJqOmo4hfVDCtUAE+JtGwkYAZ/cyW5cTnvMhx
GdYaO6ls3qGyO9fDxT/PjXiaq4r3npv6esmz4qFYIU9ETh8HwGfLdu5TUTRHx1Ci
t7hAJSD+4O5mI02EhzuFi1zAJpnZF1UM8WYtZ3Go6GIK6fRKAgwJLdPOOdDVbIjT
gfY4SkMzuKq8g9Zp4snqOqm+2QAN9DOolBziPHCcwlGfHWMC9uWgQxcw6zdVYv8e
02x+Qu25IA7ATt0vOMZRCegRTdDdXFk8NJgCgy5eXRQD92Oijb9NOYM2M5ZpyFGR
ifCg0OQTgCSQXd9qgsAqF0WGNSqZUmpGddquKLyvcLP/Ux3TlsTOrFXCMRjX18uL
/PjC3stmgdqDrp/0QzcsyP0UDQhFSa6xLxXdFEXK9JCdDq9B5xwCGWabtgK2ZFG/
KYJAUoKFT5p3B9lGn/ic2Hh3K4MO41AuEnS1C01U1RBGvAt0b5IetqigOkiIz69I
SAXCqVnRhsF7Dxxa9qLj
=9jSp
-----END PGP SIGNATURE-----

--=-p6jEQ7MvDg3Czo5URP7I--

