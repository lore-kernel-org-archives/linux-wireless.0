Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58558 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbZCXUxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 16:53:55 -0400
Subject: Re: Adhoc-demo support in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: ming li <mingli@cs.umass.edu>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <c03d7e680903241348x27363902m764c25a9a439d419@mail.gmail.com> (sfid-20090324_214907_712583_E14D9763)
References: <c03d7e680903240959s51aa4864uaad281bd7487e823@mail.gmail.com>
	 <871vsmrekh.fsf@litku.valot.fi>
	 <c03d7e680903241348x27363902m764c25a9a439d419@mail.gmail.com>
	 (sfid-20090324_214907_712583_E14D9763)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HC8wPax8ZlHdeUQKe16P"
Date: Tue, 24 Mar 2009 21:53:51 +0100
Message-Id: <1237928031.4320.133.camel@johannes.local> (sfid-20090324_215358_523224_5DCB3AF2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HC8wPax8ZlHdeUQKe16P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-24 at 16:48 -0400, ming li wrote:

> The adhoc-demo mode is also called pseudo-adhoc mode. It is simply the
> ad-hoc mode without control pkts. It does not probe for or associate
> to adjacent adhoc networks. The user has to set all the nodes to the
> same channel manually. The good thing of adhoc-demo is that it does
> not have the beaconing overhead or the IBSS merging/splitting problem.

Do you really need to disable beaconing, or would it be sufficient for
you to just fix the BSSID and the channel? You can do those two already
easily, something like
	iwconfig wlan0 ap ...
	iwconfig wlan0 channel ...

johannes

--=-HC8wPax8ZlHdeUQKe16P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJyUhcAAoJEKVg1VMiehFYcrsQAK8bky76ZKObRS+sxyf4c3wi
pbjqxFvRMqjmq05OEqnSEFdp8vpqjY2pVVd4gAYTG/uQZYindH18kVUUXPLQ/hZy
dpwgLm4RJlmiw5RNhiTbibjv6sSy92elOKmi1U7w1kWuzXjK86srD1QNpYDU3fO3
u0tAMM3q5HgpaDqoUJoMPBsl6+uTq5Q0LiWmdYhKzZ65wGnUwf8mgieYOBYvxeBL
MGEGdWkwPT9OgFEg+Rbvz8RKaPedjuCpimkWrIVZKm3Ms4rUzD966p0m2hT7/lGS
mQ1P78SiMP1fnWNZTv9ux85ygQkoFe4bquWT1/4qJxSjPshPNrOwd9O9u4eSHrSw
8vxd9D/dDPpgQ/AsrIqtVW4W/ohxgIbtyz9patjvZ0dyn+Qa6kd4zFfbJ/8Cg5T8
tkhK86DjaMZ13rudRbI8wqb4c5sfaKg9lVAs2uiohEOhbffC/cM73G7s/lqHMfnB
oBjYVYTyQf+jT7+znFJOIeX3CkQ2jtO1wfZeYTir/AYzTJDBDCxL5pgnITJd60lA
Zst4Bv0uV0qNqNIGxpWSNlEoGbZitXXe74x+etliC2qsNtoTUNhNQAJIptiVGmwS
T4CzcuY9yWPQMiQTYAFkG5/k8Xow2/nikJwKS8MYNHJtC9O+lsU7ZXp6mkmgMf55
f5QZ1GW7JktJ7/wwGu4N
=XR/X
-----END PGP SIGNATURE-----

--=-HC8wPax8ZlHdeUQKe16P--

