Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:55239
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750797Ab3KGQhi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Nov 2013 11:37:38 -0500
Date: Thu, 7 Nov 2013 11:37:19 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: future of prism2_usb (aka wlan-ng) in staging tree
Message-ID: <20131107163719.GC12612@shaftnet.org> (sfid-20131107_173758_908010_D453F0F2)
References: <20131107160522.GA12612@shaftnet.org>
 <527BC04F.2080000@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gatW/ieO32f1wygP"
In-Reply-To: <527BC04F.2080000@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 07, 2013 at 10:31:11AM -0600, Larry Finger wrote:
> This seems like a good point to clarify what it takes for a wireless
> driver to be added to net/wireless.
>=20
> Is it necessary that any new softmac driver in net/wireless must use
> mac80211, or is it sufficient that it implement cfg80211?

IMO a softmac driver should use mac80211 before being merged; there's no=20
sense in having multiple 802.11 stacks especially with the ever-growing=20
complexity of 802.11.

But in this particular case, prism2_usb/wlan-ng is perhaps the original=20
fullmac 802.11 device.  :)

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org
Delray Beach, FL                          ^^ (email/xmpp) ^^
Quidquid latine dictum sit, altum viditur.

--gatW/ieO32f1wygP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iD8DBQFSe8G/PuLgii2759ARAvvoAJoCaBn+p/WuCd36wZ1uyy0NHdUGYgCgumry
4K6osmPbpk6Z/w97Q48m3x0=
=r+To
-----END PGP SIGNATURE-----

--gatW/ieO32f1wygP--
