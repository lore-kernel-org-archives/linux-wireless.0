Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:58157 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbYKDDLu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 22:11:50 -0500
Date: Mon, 3 Nov 2008 20:39:56 -0500
From: Forest Bond <forest@alittletooquiet.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: b43: Everybody with PHY TX error, please try
Message-ID: <20081104013956.GB483@storm.local.network> (sfid-20081104_041230_108472_69F87045)
References: <200810242032.04295.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3uo+9/B/ebqu+fSQ"
In-Reply-To: <200810242032.04295.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 24, 2008 at 08:32:04PM +0200, Michael Buesch wrote:
> Everybody with PHY TX error, please try updated firmware from
> ftp://ftp.linksys.com/opensourcecode/wrt610n/1.00.00.018/wrt610n_v1.00.00=
=2E018_us.tgz
> (Yeah, big tarball. It's 87MB)

Sorry, I'm arriving to this late.  I'm seeing the following:

[30447.008408] __ratelimit: 2795 callbacks suppressed
[30447.008466] b43-phy0 ERROR: PHY transmission error
[30447.008496] b43-phy0 ERROR: PHY transmission error
[30447.008523] b43-phy0 ERROR: PHY transmission error
[30447.008551] b43-phy0 ERROR: PHY transmission error
[30447.008577] b43-phy0 ERROR: PHY transmission error
[30447.008606] b43-phy0 ERROR: PHY transmission error
[30447.008634] b43-phy0 ERROR: PHY transmission error
[30447.008662] b43-phy0 ERROR: PHY transmission error
[30447.008690] b43-phy0 ERROR: PHY transmission error
[30447.384079] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:3=
2:10)
[30447.500347] b43-pci-bridge 0000:02:00.0: PCI: Disallowing DAC for device
[30447.500376] b43-phy0: DMA mask fallback from 64-bit to 32-bit
[30447.526191] Registered led device: b43-phy0::tx
[30447.526960] Registered led device: b43-phy0::rx
[30447.527543] Registered led device: b43-phy0::radio
[30454.780114] wlan1: No ProbeResp from current AP 00:1e:2a:e4:de:84 - assu=
me out of range
[30455.681012] wlan1: authenticate with AP 00:1e:2a:e4:de:84
[30455.682225] wlan1: authenticate with AP 00:1e:2a:e4:de:84
[30455.684847] wlan1: authenticated
[30455.684873] wlan1: associate with AP 00:1e:2a:e4:de:84
[30455.688707] wlan1: RX ReassocResp from 00:1e:2a:e4:de:84 (capab=3D0x411 =
status=3D0 aid=3D1)
[30455.688730] wlan1: associated

This happens repeatedly during file transfers.  Everything is quite slow.  =
You
can see that the device was reset.

Will the firmware upgrade fix this?  Must I be running the latest b43 drive=
r to
use the new firmware?

I'm on Ubuntu 8.10 with kernel version 2.6.27-7-generic.

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--3uo+9/B/ebqu+fSQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJD6fsRO4fQQdv5AwRAmXhAKCo7OQM/iOtYQQyGCgXuvW21GWUAQCgs7eV
oP1f4J1JcEkImZDS9dokRr8=
=bH8I
-----END PGP SIGNATURE-----

--3uo+9/B/ebqu+fSQ--
