Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server8.tchmachines.com ([216.180.241.250]:57204 "EHLO
	server8.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbXCDF2H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2007 00:28:07 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] bcm43xx: remove ethtool
Date: Sun, 4 Mar 2007 00:04:48 -0500
Cc: Larry Finger <larry.finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
References: <45ea1a34.Lf4EKmMy+KAmSkH0%Larry.Finger@lwfinger.net> <45EA3D21.3080203@lwfinger.net> <45EA43EF.1080009@garzik.org>
In-Reply-To: <45EA43EF.1080009@garzik.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3058243.NkWeZE2nZr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703040004.57974.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3058243.NkWeZE2nZr
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Saturday 03 March 2007 22:58, Jeff Garzik wrote:
> It's a highly standardized interface that provides information that's
> either impossible or highly difficult to obtain elsewhere.
>
> If you are a userland process querying a network interface, that's the
> only way to know which driver is attached, or the only way to build an
> association between a PCI device and a network interface.
>
FWIW, on my system:
/sys/class/net/eth1/device -> /sys/devices/pci0000:00/0000:00:10.4/usb1/1-7/1-7:1.0
/sys/class/net/eth1/device/bus -> /sys/bus/usb
/sys/class/net/eth1/device/driver -> /sys/bus/usb/drivers/zd1211rw_mac80211

And the other way around:
/sys/devices/pci0000:00/0000:00:10.4/usb1/1-7/1-7:1.0/net:eth1
/sys/devices/pci0000:00/0000:00:10.4/usb1/1-7/1-7:1.0/net:wmaster0

Is this considered highly difficult or not standardized enough?

-Michael Wu

--nextPart3058243.NkWeZE2nZr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF6lN5T3Oqt9AH4aERAjO5AKDWGlxM2Bw36/Y0s84BODmUBU4spwCg0iwC
PvK+BGxoQpKb8eNJEdShlFg=
=RKnH
-----END PGP SIGNATURE-----

--nextPart3058243.NkWeZE2nZr--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
