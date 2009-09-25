Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42392 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbZIYInn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 04:43:43 -0400
Subject: Re: 2.6.31-git wireless broken
From: Johannes Berg <johannes@sipsolutions.net>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-wireless@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0909250838420.3783@sister.anvils>
References: <Pine.LNX.4.64.0909241737390.20846@sister.anvils>
	 <1253813740.3868.324.camel@johannes.local>
	 <Pine.LNX.4.64.0909241859020.25022@sister.anvils>
	 <1253816614.3868.406.camel@johannes.local>
	 <Pine.LNX.4.64.0909242036270.7469@sister.anvils>
	 <1253856038.3868.500.camel@johannes.local>
	 <Pine.LNX.4.64.0909250838420.3783@sister.anvils>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-E3MgaVi3N7cW6e72LS+H"
Date: Fri, 25 Sep 2009 10:43:34 +0200
Message-Id: <1253868214.3868.713.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-E3MgaVi3N7cW6e72LS+H
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-09-25 at 09:06 +0100, Hugh Dickins wrote:

> Should be, but you're right, for whatever reason it is not running
> with these recent kernels.
>=20
> I expect that correlates with iwconfig showing me ESSID:off/any.

Well it showing you that means that nothing is even trying to connect :)

> I'm thinking that (unless you've a better idea) I should do another
> bisect for when that behaviour starts - hoping that whatever problem
> led me to your patch, got fixed up later on, but superseded by this
> different problem.

Not sure, might be very time consuming.

> The bootup messages on the Aspire One tell me:
>     wlan0     device: Atheros Communications Inc. AR242x 802.11abg Wirele=
ss PCI Express Adapter (rev 01)
>     wlan0     is controlled by ifplugd
>     wlan0   =20
> waiting
>     wlan0     device: Atheros Communications Inc. AR242x 802.11abg Wirele=
ss PCI Express Adapter (rev 01)
>     wlan0     ifplugd is running
>     wlan0     no cable connected
>     wlan0     DHCP4 client NOT running
>     wlan0   =20
>=20
> And the bootup messages on the Fujitsu Siemens say:
>     wlan0     device: Intel Corporation PRO/Wireless 3945ABG [Golan] Netw=
ork Connection (rev 02)
>     wlan0     is controlled by ifplugd
>     wlan0   =20
>     wlan0     device: Intel Corporation PRO/Wireless 3945ABG [Golan] Netw=
ork Connection (rev 02)
>     wlan0     ifplugd is running
>     wlan0     no cable connected
>     wlan0     . . . is just beeing set up
>     wlan0   =20
>=20
> In each case, "no cable connected".

Oi. This looks like it doesn't know that it's a wireless device I guess?

johannes

--=-E3MgaVi3N7cW6e72LS+H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKvIKyAAoJEODzc/N7+QmaUPwQAJgcl2uT99MxgJ931sadjL3h
QrwGW99mF4ku+T4CzTuqAUhkn9p2OVMkrCtnXkH/KaOXWXkZI1psG/2xznT2tNTS
rTlEVN2mMah8wW2EgKU6N+qsu0sR9ysPz8MislQoURyte0s5cWGWVM0eWkZHkv1E
KkpxnzKhr7K22xC4rvqWwyrdTMxIY9S5mlVcLDVCilpMSiBFQ3Nq2gChpjMaJJF6
jJMNE+uj3SFXBIBzjD8ky0lU74WHz7pxpIvkCnqOAq+JHfJtoXodDnL46mm6EPux
Deh0kIPzvISwVuxUWI+kohvaq9aCXSW3htFzVZ/L7lYP6sIUla1eUq5IwQtbx20T
akJX+vbzhYXENB2eCsf2Fpk88NCzxky77aZ4SmQl0N+6eiroPq8yxzOXtqJI/B/l
EM3BGwTXDvwg9K4YoSF/AVnnP1pdDazKulUZiaQVKJYovAErmeT58XABnP4ECtCz
RCJWhWhyO9yvt3/cOdK7PAcKYOn+XS0mrLw053veOhh4rgQRu0KZxqJqUWkuR9km
pa/Yd4ZUjm7pSvKe+74FEmCdmonGQYCPhYtlZUDRtGVDpMwT77H5PMCNijexCF4G
goZs1F3Se1xDutZUlsT8JeftEiSSOCHT7HPkkQwDXPHvP2hkD69DhPipb1/jN8jw
e3gN/16zy1Q7VHgnSTvK
=zFgN
-----END PGP SIGNATURE-----

--=-E3MgaVi3N7cW6e72LS+H--

