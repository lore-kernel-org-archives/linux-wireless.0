Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752314AbcLQMD4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Dec 2016 07:03:56 -0500
Date: Sat, 17 Dec 2016 13:03:50 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Gery Kahn <gery.kahn@gmail.com>, Shahar Lev <shahar@wizery.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: Re: wl1251 NVS calibration data format
Message-ID: <20161217120350.phnlfhklwfqqgbjr@earth> (sfid-20161217_130416_867948_E62952F1)
References: <201612161201.48356@pali>
 <20161217093705.p64yzumqlu3u5aq7@earth>
 <201612171214.50820@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hb34bhk3syf6mknf"
In-Reply-To: <201612171214.50820@pali>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--hb34bhk3syf6mknf
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Dec 17, 2016 at 12:14:50PM +0100, Pali Roh=E1r wrote:
> On Saturday 17 December 2016 10:37:05 Sebastian Reichel wrote:
> > On Fri, Dec 16, 2016 at 12:01:48PM +0100, Pali Roh=E1r wrote:
> > > Hi! Do you know format of wl1251 NVS calibration data file?
> > >=20
> > > I found that there is tool for changing NVS file for wl1271 and
> > > newer chips (so not for wl1251!) at:
> > > https://github.com/gxk/ti-utils
> > >=20
> > > And wl1271 has in NVS data already place for MAC address. And in
> > > wlcore (for wl1271 and newer) there is really kernel code which is
> > > doing something with MAC address in NVS, see:
> > > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tre
> > > e/drivers/net/wireless/ti/wlcore/boot.c#n352
> > >=20
> > > So... I would like to know if in wl1251 NVS calibration file is
> > > also some place for MAC address or not.
> > >=20
> > > Default wl1251 NVS calibration file is available in linux-firmware:
> > > https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmwar
> > > e.git/tree/ti-connectivity/wl1251-nvs.bin
> >=20
> > Pandora people [0] have a description of the format at [1].
> >=20
> > [0] https://pandorawiki.org/WiFi
> > [1] http://notaz.gp2x.de/misc/pnd/wl1251/nvs_map.txt
>=20
> Thank you very very much!

You are welcome.

> I tried to search for something, but I have not find anything.
> In that description is something about STA mac address:
>=20
> 01a       6d           //STA_ADDR_L Register Address.  (STA MAC Address)
> 01b       54           //
> 01c       00           //STA_ADDR_L Register
> 01d       00           //
> 01e       32           //
> 01f       28           //
> 020       00           //STA_ADDR_H Register Data.
>=20
> STA would be abbreviation for station and so it should be really set to=
=20
> mac address of that chip?

Yes, STA is a common abbreviation:

https://en.wikipedia.org/wiki/Station_(networking)

> If yes, that could allow us to set permanent MAC address at time when=20
> loading & sending NVS calibration data... Exactly same as wl1271 and new=
=20
> drivers are working.
>=20
> I will try to play with driver if it is really truth!

Thanks for your work.

> I already looked into original TI's multiplatform HAL driver for wl1251=
=20
> chip (big mess) and found there that there is wl1251 command to read mac=
=20
> address from chip. It could be done by this wl1251 function:
>=20
> wl1251_cmd_interrogate(wl, DOT11_STATION_ID, mac, sizeof(*mac))
>=20
> (same id as for setting permanent mac address, but opposite to read it)

-- Sebastian

--hb34bhk3syf6mknf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlhVKaMACgkQ2O7X88g7
+ppzSRAAgz+JEnWSUtLx+ldkG70k4gVQlOqH+hFEqOiMa4c0FBR6MZdRzeqKvQCQ
OH6/RPa5FewfltR4diUqaxZLPMTHKA6wi49lVsgwOXCs/WdTKtObJQpCV9dD/oQe
ZINslXSXR8qWiK3U8b9nry7XtIVmXoIb5dIZyLkqFS0vka79sYrajkw17K/3zCjH
I8HYb7MjK4enb4w8pcc5FcXon12FDAiKiMqgU5xiTdO990wjf8Prhc+IzPiVM6uM
uDR5VyFhNjYKYMM3zcw5vWWDnfLDW98aJF+M0u1f/WDAINvo9dhhyyrG+0/HuEdn
Qw4Xzs1w4ZlLPqT0Qira0MH56MMUASrIf35LJqcFWQ8C/V4WRQc/7kyarNacunXn
d1KIv7Ai0oejmJG6wHZV9Eby2XVtzQ7cNYKO5nq1wb8CAg2seJvfGl/h5NI8GIuZ
I5TRyuksxAemkfNQl1Npa4S5aWkRZVI0HR919xF0YAJexGdi+x52mkkPb18xSaG8
YqE2bK8Cdn6U7MnZNWwGLK5w+TiE2a1aXnzy1n0SBmBEg6qDnvfogWy5pnonsEte
DPeqYIHQK5BQeEoznaGpI35yvNf9mtPO+1gw1G/2D5/IMUIW7BTyW4T/9YcP+9x2
eTKezUMS6Mmvh5NnbDO4hhwg2v5dkJ4GLwNJnTkbob2Jf/YywZA=
=B9ot
-----END PGP SIGNATURE-----

--hb34bhk3syf6mknf--
