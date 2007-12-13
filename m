Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41132 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbXLMMcK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 07:32:10 -0500
Subject: Re: [PATCH] try 2: mac80211: Fix swapped parameters to
	ieee80211_set_channel()
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Lunn <andrew@lunn.ch>
Cc: flamingice@sourmilk.net, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <20071213120904.GB501@lunn.ch> (sfid-20071213_120944_016806_DBA9D772)
References: <20071212153158.GB16947@lunn.ch>
	 <1197481426.6558.138.camel@johannes.berg> <20071212180204.GP31218@lunn.ch>
	 <1197482969.6558.149.camel@johannes.berg>
	 <1197504975.6558.199.camel@johannes.berg>  <20071213120904.GB501@lunn.ch>
	 (sfid-20071213_120944_016806_DBA9D772)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-90yBXcdgpNOp+ddFN5NV"
Date: Thu, 13 Dec 2007 13:30:25 +0100
Message-Id: <1197549025.6558.253.camel@johannes.berg> (sfid-20071213_123214_940004_FBABB5F7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-90yBXcdgpNOp+ddFN5NV
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


> iwconfig wlan0 freq 5240

man iwconfig(8)

       freq/channel
              Set the operating frequency or channel in the  device.  A  va=
lue
              below 1000 indicates a channel number, a value greater than 1=
000
              is a frequency in Hz. You may append the suffix k, M or G to =
the
              value  (for  example,  "2.46G"  for  2.46 GHz frequency), or =
add
              enough =E2=80=990=E2=80=99.

johannes

--=-90yBXcdgpNOp+ddFN5NV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2El4KVg1VMiehFYAQL5Gw//cbcyAWTNJb7de9lc8QyqdmQuQW1n/BYv
5YGWw7+JVaXnsyVphnhJC/eIrOkFnmVn9ut0uec6S1MOEb9f3aBJS/fF1YlBOVyw
xEvuDMrDnkRJCYUm/kz6eeLOqV5Tz1qUpE1e5IxcEReyv4XL9dUQGw64UaLo+6a0
DUTYeTQk/F19UyJlEILtDFmeL18dKM5kqvusq2j0kTiXmZcVjFxoG1ciljdm6vAb
JHJvtgL4JwNKxck2iJiqVCe5Ki/TfKRlVLqQHo+ARvh3pRZl/tHQmJlv6TqtBHuk
6rBNLb2NcMee7DiXtGAZSCxkbdoOlFKcXOcueQmQ8hF1UEq8A7bggQDsDaXhK7OM
VXWkvak9oP4bXk7WQ6NhVV6jPGmSPGhergdiaC099nqFb2DwgKyrV3QRmd72G0/i
2PhaVObSy9Rw5+6U58EnhX01PRzHjjXjRHxpmZ3VI+JbOmQC1XINX2bhVhsbetCZ
0DlAMq2Y+1ANIb9vbrjbQg+AO0cPnKcvuRY+ynFxPhQUd3RqRp0PN892E86JaiUY
t3eHqt2Wagpzes5XyVOzVbk6dlkOrniFq2myeVWYT4NJtL6Ao7PWMy57tqgD8W8k
uw5Q3muUJpGdFXaPBXSe50u6TSzdqzy2DaNl7NUFzgA8mdmShGXzqM1rSsMq2FiD
FxP8iJ/Gxpw=
=4iVR
-----END PGP SIGNATURE-----

--=-90yBXcdgpNOp+ddFN5NV--

