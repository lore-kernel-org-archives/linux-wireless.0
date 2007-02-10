Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lugor.de ([212.112.242.222]:48192 "EHLO solar.vpn.lugor.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750979AbXBJNku (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Feb 2007 08:40:50 -0500
From: "Hesse, Christian" <mail@earthworm.de>
To: James Ketrenos <jketreno@linux.intel.com>
Subject: Re: [ANNOUNCE] d80211 based driver for Intel PRO/Wireless 3945ABG
Date: Sat, 10 Feb 2007 14:23:55 +0100
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, netdev@vger.kernel.org
References: <45CCE3CA.4050904@linux.intel.com>
In-Reply-To: <45CCE3CA.4050904@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1331304.FZbrcmnoEp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702101424.00156.mail@earthworm.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1331304.FZbrcmnoEp
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 09 February 2007 22:12, James Ketrenos wrote:
> We are pleased to announce the availability of a new driver for the
> Intel PRO/Wireless 3945ABG Network Connection adapter.

Wow, great news on this rainy saturday! ;-)

The driver works perfectly, I'm writing this mail via wireless link. Howeve=
r=20
there are two things to note:

The driver generates two network devices. The second one is for promicious=
=20
mode? Is there any chance to disable the interface? ifrename renamed the=20
wrong one to wlan0 and I had to tell my system to use eth1 for the wireless=
=20
connection.

Second problem is that I can't unload the module. I get the message "FATAL:=
=20
Module iwlwifi is in use." even if both interfaces are down.
=2D-=20
Regards,
Chris

--nextPart1331304.FZbrcmnoEp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBFzcdwlZfG2c8gdSURAvfiAJ4nWHv3+Jz4m+AJbHwUN3VVmqOmoQCgktqe
rgsCSbzhtU3sd2uTVluX1K8=
=T5s0
-----END PGP SIGNATURE-----

--nextPart1331304.FZbrcmnoEp--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
