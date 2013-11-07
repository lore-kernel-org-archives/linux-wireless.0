Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:53553
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751535Ab3KGQRh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Nov 2013 11:17:37 -0500
Received: from stuffed.shaftnet.org (localhost [127.0.0.1])
	by stuffed.shaftnet.org (8.14.7/8.14.7) with ESMTP id rA7GHaHl025001
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 7 Nov 2013 11:17:36 -0500
Received: (from pizza@localhost)
	by stuffed.shaftnet.org (8.14.7/8.14.7/Submit) id rA7GHaYF025000
	for linux-wireless@vger.kernel.org; Thu, 7 Nov 2013 11:17:36 -0500
Date: Thu, 7 Nov 2013 11:05:22 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: Greg KH <gregkh@linuxfoundation.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: future of prism2_usb (aka wlan-ng) in staging tree
Message-ID: <20131107160522.GA12612@shaftnet.org> (sfid-20131107_171740_849928_38841C7D)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Greg, John,

I was wondering what it would take to get the prism2_usb/wlan-ng driver=20
out of its long home in the staging tree.

It's seen some work over the years, including conversion to cfg80211,=20
and in general seems to be no worse than its ancient bretheren already=20
living in net/wireless (ie orinoco and hostap)

There's certianly more internal cleanups that can be performed (eg=20
collapsing more unnecessary internal APIs such as the MIB handlers) but=20
at face value it would appears that the TODO items in the README have=20
been met (other than shutting up checkpatch's style warnings)

I'd be willing to take point on this and make checkpatch happy, but I'm=20
curious to hear your thoughts on any additional work you think is=20
necessary to get it out of staging.

Cheers,

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org
Delray Beach, FL                          ^^ (email/xmpp) ^^
Quidquid latine dictum sit, altum viditur.

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iD8DBQFSe7pCPuLgii2759ARAiWnAJ4/fDdheKcj5OT0ftzlDlT8y0OYOwCdE/Xg
1qU1IPYPBiNTNuJ60sDxlno=
=Xy/y
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
