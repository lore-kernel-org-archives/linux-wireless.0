Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35060 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781AbcAYMSp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 07:18:45 -0500
Date: Mon, 25 Jan 2016 13:18:40 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
	Alexandre Courbot <gnurou@gmail.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Marc Dietrich <marvin24@gmx.de>
Subject: Re: [PATCHv2 3/4] ARM: tegra: use build-in device properties with
 rfkill_gpio
Message-ID: <20160125121840.GA20452@ulmo.nvidia.com> (sfid-20160125_131904_133363_C2505022)
References: <1453712629-143317-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1453712629-143317-4-git-send-email-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
In-Reply-To: <1453712629-143317-4-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 25, 2016 at 12:03:48PM +0300, Heikki Krogerus wrote:
> Pass the rfkill name and type to the device with properties
> instead of driver specific platform data.
>=20
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> CC: Alexandre Courbot <gnurou@gmail.com>
> CC: Thierry Reding <thierry.reding@gmail.com>
> CC: Stephen Warren <swarren@wwwdotorg.org>
> ---
>  arch/arm/mach-tegra/board-paz00.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)

Looks fine to me. We might want to wait for Marc (Cc'ed) to give this a
spin, since I don't have the hardware. For reference, the series can be
found here:

	http://patchwork.ozlabs.org/patch/572640/
	http://patchwork.ozlabs.org/patch/572644/
	http://patchwork.ozlabs.org/patch/572643/
	http://patchwork.ozlabs.org/patch/572642/

Johannes, I assume that you'll want to take this through your tree
because of the dependency? In that case:

Acked-by: Thierry Reding <treding@nvidia.com>

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWphKcAAoJEN0jrNd/PrOhVlMP/i5QMgu5bU6jLEAYoubopBXw
VgZPSBqaddHK6qgVntB/9kwD6o8h11xb3FSE4yOSy7bLHHkUjYNpbVPY395nhkCW
mwevqUgh7RjD5sRXPdbT0wbqzRQ6+/1glS+yqV2CL49o8wPasYOsmJifZw0hyG0j
/5N0b4Tgq4PgZbjh02kVNcwPMc6mV2lrNCRkOi8TBsXoHHNUA3D1m7/qW2Hr0vEi
PFJzPddKsEIpoUnohzhxrbwsZUXCg+Cdan25FWU8a/P7hmM/PvyY/lalsJ+2pZAc
V3NeMgAUldNbubzsFoSL041OHIo165aqQZozYDBbhLaUbsIeAw66C3LwO3+6GLLG
86gsMlk8vDD91Lh3ZG29Z6wS7cxnDCxGTTl3ltjbivS7ohdd+XP8ChCBExVdb+YQ
Jw4QvIr6rPWXLzEhkSGEj6MinCcSPD7RrIJp0Z204LBIbuy+nXdhzSNH2V3WuU0C
zJuHyElAuCNN5UadBPaVopFIRMwxtDRpmDUiVFcBvPIQx5BCxYD1pP1M1XR9SQIE
X5lHJ5WI6Z5hG/Z183wK8wuGx9itVbviSg9V+Po2eFk3dWzEJ8AHbx4mJtKgLhks
1MhnQrWH3mCIjDF9W0Y5PNcuYd6HBesV/gY84BdGO5xy6cdT57LfI6ZTubIYZIhM
TbiCVZw9K1FvOObSqanK
=8JOH
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
