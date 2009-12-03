Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60973 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339AbZLCSwW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 13:52:22 -0500
Subject: Re: [PATCH v2 3/5] mac80211: correctly place aMPDU RX reorder code
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1259864007.4653.298.camel@rc-desk>
References: <20091125164614.427835023@sipsolutions.net>
	 <20091125164821.184669673@sipsolutions.net>
	 <1259864007.4653.298.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-u0cptRYj5qaiDEl6sNHj"
Date: Thu, 03 Dec 2009 19:52:21 +0100
Message-ID: <1259866341.12843.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-u0cptRYj5qaiDEl6sNHj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-12-03 at 10:13 -0800, reinette chatre wrote:

> I bisected a hang problem to this patch. When associating to an 11n AP
> (tested on 5GHz), ping works fine, but trying to copy a large file
> causes the system to freeze (keyboard lights start blinking and system
> unresponsive. Reverting this patch I can copy large files successfully.

Ouch. Thanks for the report/information, I'll look into it promptly.

johannes

--=-u0cptRYj5qaiDEl6sNHj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLGAjhAAoJEODzc/N7+QmaaXUP/iIdUpC4jGa4xXktC0Ju6AjJ
FDSHe8Is4q+oIzCGYBaz/dCyRSDFC/EikUoibSbiQuus0+pXdIHL1imzmpupkSlh
XMzNO6bFGSzpgpZhTsawAc3t7WBfynMxrkw99mhT+unFx6930au+mI3Ji26Zyoin
yhK1NFP9ADV8+lW9sjMNCylMFSpfsn0iKxJIoPQbAcxDuxnWWMDjkOZXLQiVBbxc
2vD6ZqLN6HdjjSQQ4Ljzqhhm3MXRZTEuHdx5ErjGFaZaANpRNcdpTiGAOXfQWLNQ
YOTdo1m7Q+JzSUYelZ/ohBnej82JLOlCRhgXRBxtFDP6Exhp16B3dV+AnAA7CE1c
g2w9wUDw/GS1yZO26koDplSkOlAXK+IOet0Z+5777yRu2xB/dlQkXT3qQY3aquR2
c3Mn+zxbJnkNW0XswFpm7dLgM9yv845HqcBSyjj6FChzYsJFw1h3LrQbwdEeePbM
IO45s0lEZ8o19eeVrd+ty9woZDMq1pRBhNOmBuHcUOUaIPvefgUTLbd/0hCgbDFC
moaIcpRP8jSE8nqpd+R8zLhAAqHWOKY+Qo/oQPnJv1H4hoxsHWMHOtaCxb3qDEpy
PVRzVI0Wa8TyUIGsR/VpdXkoBrUE7MR2EYapC7QGwuqyXGSC2bqJ5VxDWn0WsrhT
nXEK7WlZlVQzuaKsR3bX
=+Sog
-----END PGP SIGNATURE-----

--=-u0cptRYj5qaiDEl6sNHj--

