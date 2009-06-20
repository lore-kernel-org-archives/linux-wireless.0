Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53412 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbZFTLeN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jun 2009 07:34:13 -0400
Subject: Re: Question about rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4A3C5D49.2000106@lwfinger.net>
References: <4A3C5D49.2000106@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Nx3TRqvJk+uiUGo8hToJ"
Date: Sat, 20 Jun 2009 13:34:13 +0200
Message-Id: <1245497653.16399.27.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Nx3TRqvJk+uiUGo8hToJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Larry,

> What is the reason that rfkill_get_global_sw_state() is not exported?
> A call to this routine seems to be the ideal replacement for the
> deprecated radio_enabled.

No need, radio_enabled is intended to be removed, because if you rfkill
now cfg80211 will force the interfaces down. Some time later way may
need to add a way to disable just the radio again, but that will be
different and for different purposes.

johannes

--=-Nx3TRqvJk+uiUGo8hToJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKPMkyAAoJEODzc/N7+Qmao8EQAMT1O41TSvBrbYs66nsSp5Ba
EISMYYoKQiee/FHj2LsTnLGegz+ucOUJISp7ofn3VNLtW1nuQ8gnChpxsTbAPumX
XIPNOsuhN9xuHMe25UZmuLpBDAejFVWuia2WuDgJ0GTy2dT8dxaWyb52Lnu9sLvu
v1cGTSly352COA6UfmRuu7zbckj+VK8cxJgOm1Da6kxEKBs+/2o/m9JqFG9iqVZq
6zPTYsVadNe7OyesHIDqDL5sPbkpyLFjwEffkoA6ca2VCRTAFiQKM3s6tWjJ2Fak
cqI++CH+7YNBCQF0Yy3HXDRD9tVQevYEbHowjLHDpyyjO21OvYziPobeIVc/qIad
sgEbjM8oaP4kOmPoCsbWfQSqn/dTIRLf1G38kqgmZui5qmLLe0cfRmqOa0KRevem
AddXaq09ASvyAkZNBOeSOfQwVd/CGCKcRMn0gNRZ6MFcca9Ag7eS4c0kUWcJ7OS+
DcbtB+zKDhXP0od8JZnk1PaKDXn3A6DwhcdQKU4gICaGGfOktyd41dP/EgejGLdv
YLq5uCA6ZF3ipC33fmzfXIfbFnHEwJRt1jEJ/VZ4GRa5Xb9RfaG9lSy2NB1q2fyU
h0rC9rlTshVvwGOAG65y3IZ9VDaf87W1c7nXec0fqjm0drfEiJtQn09ur4CxnZ0X
CqotBjW7cHXhRIzdL+Yp
=F6ke
-----END PGP SIGNATURE-----

--=-Nx3TRqvJk+uiUGo8hToJ--

