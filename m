Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173013pub.verizon.net ([206.46.173.13]:46681 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab3BUNRp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 08:17:45 -0500
Received: from odin.tremily.us ([unknown] [72.68.84.219])
 by vms173013.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0MIK00FKJKSZQN60@vms173013.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Thu, 21 Feb 2013 06:17:24 -0600 (CST)
Date: Thu, 21 Feb 2013 07:17:22 -0500
From: "W. Trevor King" <wking@tremily.us>
To: linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: rev-17 Broadcom core support in b43 and CONFIG_B43_BCMA_EXTRA
Message-id: <20130221121722.GA23690@odin.tremily.us> (sfid-20130221_141750_876077_F3859673)
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=ZGiS0Q5IWpPtfppv
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I've been poking around in b43 and brcmsmac trying to wrap my head
around device detection.  Obviously, b43 and brcmsmac both support
some devices, and since 4f3d09d (b43: add option to avoid duplicating
device support with brcmsmac, 2012-01-11) overlapping devices have
been masked behind CONFIG_B43_BCMA_EXTRA.  At the time of that commit,
brcmsmac didn't support the r17 cores, but support has since been
added in 6f80f01 (brcmsmac: add support for cores with revision 17,
2012-12-07).  Does that mean that b43 should move the r17 core entry
into the masked-by-CONFIG_B43_BCMA_EXTRA block?

Cheers,
Trevor

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRJhBRAAoJEEUbTsx0l5OMCSsP/AjZlJO5xu0h/bPWJ4FIZCGW
3G4ZQs2veT3LFs62Ec7Fo0BJYtqWFOv1tpU8d+joireJ8YV1mccOQXfpeClKzgWq
eYj9zSsbIz+0mjsQfQ1ENI+mRHUlsy43sM/JFpZ13kqhE6+Jq0DpXdK476P4M/gX
HMqN84eqIlJk5OIi9eh52EINoXEaLVIVSPkAWHZ3AIws72YF5UF7gawFrySd8dQ+
qpHn1uasEo+CfTmoJi7TyfQTeD+qqK65apO6xZbx9UrZu9hKOE852ZV2lFK1g9Qh
yml//NgQsV/LSPrQiZd+YwwDV0gDCMMihKgDkDhIdFaa3F/jG0TOlq/WTlU653zr
eKTBTW8dUCRqNiUN8vsogQVDlK5u+TWffPJ7ranowtlHctsJgV+HEMEIk7cyl0jG
n6mi+zSujXziEZJkt6FC4nEYSiiMJkSxYoKMUwlavdFGbpoDSRQ6q/pbY2eryhOT
YfBWd91usZ9VVJIVVv60fKIJb1Kx8pX7gdQ7rNRt131uV2/kQyLyUxE2ZGd6nbYx
/pgy+DonObTCruMidRp2drQUlx1sRi7xOe6jN0tQNAeYSdDYlzD+lBMBomxMRkay
2vgepklS0qYhbw89pzR2Vz/y16CwfUbWV/BIeGy45bzGCp4jhPnx/NfluJCVL6ES
OOVPqI14WxlPYrWaZPsV
=Ogm/
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
