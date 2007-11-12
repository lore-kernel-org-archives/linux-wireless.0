Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44184 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbXKLQe3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2007 11:34:29 -0500
Subject: RE: [PATCH 12/14] iwlwifi: 802.11n comply HT add station flow
	withmac80211 framework
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Winkler, Tomas" <tomas.winkler@intel.com>, flamingice@sourmilk.net
In-Reply-To: <1879838866982C46A9CB3D56BA49ADEB0400879A@hasmsx411.ger.corp.intel.com>
References: <1879838866982C46A9CB3D56BA49ADEB0400879A@hasmsx411.ger.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-05Ip2M8NW+oGrbhxyVsY"
Date: Mon, 12 Nov 2007 17:35:49 +0100
Message-Id: <1194885349.5229.50.camel@johannes.berg> (sfid-20071112_163431_925829_8A3DB077)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-05Ip2M8NW+oGrbhxyVsY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Oops sorry, I have already took this remark out, it was just a reminder
> for=20
> me to ask you if you think that mac80211 should give the low-level
> driver some kind of query option to its station table? It may save
> double book keeping of station table to low-level driver?

Does the driver actually need to do bookkeeping? I don't see why that
would be necessary if the ucode does it. If the driver will actually
need to do bookkeeping then I'm all for adding an iterator for the STAs
in the style of the virtual interface iterator I just added. But I
wouldn't want to add it if the driver doesn't need to do any bookkeeping
(other than maybe the number of stations) anyway.

johannes

--=-05Ip2M8NW+oGrbhxyVsY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARziA46Vg1VMiehFYAQJ4+RAAvx8ZH70WujO2BrwvhU3LSnShabBXzZaT
cdKxgDJpORjrVDEVQhoH4J+XvD1lqk+FZ8k5ICb5y5l7RR3wjKR4ettujg88ONT7
Uo3DfDlwQolS95bcliDteWe0QjRppPA1x9zxXbFXtQ8KubjNjYEzVluMiPx+z5Z4
ZYlzwpHb20JCGgUhjMnPXcS+L9SIcY/mMPk72ro8c18WLJ2+31E8eYUK6eKzITD7
Q1nBiL9+h3EjtUbRXROgyQ533B0DM9lMpAQa5LqhXxAwF1nZH437u24VxUWdlsOn
kQ3+Lk4OmpK4BsfMIrYtFM5tSIOWOYe3XtPCGPQx/qmW5xRCIc5fdjpjvyvGUA6c
72yYc8AX9Yox7PFgNWEaURbuMWdnpJGsiQGQm+eZOCfWYhADpEJRLGalvov9W0Br
UcMnDXlfh8qiVRVH7vRe9OtVo8xQgFlPQLPo7ryAR+kqbPPryf+Qc5ugciCWZu6b
1U+Zvx7ZjJ53fP1uiIoxGuiLIMnXoiVVLfk+3eq3cOLqFJXvylgUQH896cALYOZ9
Z/ArdcwbrGx4lAnm+En27PCvAY303XQw5uTkd55KFK17yXDCx0ZKGNN0Ebs7ourI
2RwFTiZ51bVokdpJZY3uMeFAqa5drtyRD9N74hMgRoEojOcLiR1Ubpi9hsfdRxwH
qkTBLbn9bM4=
=ndxL
-----END PGP SIGNATURE-----

--=-05Ip2M8NW+oGrbhxyVsY--

