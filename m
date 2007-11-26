Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59248 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbXK0NG7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 08:06:59 -0500
Subject: iwlwifi driver vs. mac80211 vs. duplicate transmissions etc.
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-t/GrD7snpEcPWI8lVJr/"
Date: Mon, 26 Nov 2007 21:56:58 +0100
Message-Id: <1196110618.13733.2.camel@johannes.berg> (sfid-20071127_130702_468692_52980064)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-t/GrD7snpEcPWI8lVJr/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Is there any reason the driver tries to drop duplicate packets, out of
order fragments etc? That's just extra code and mac80211 does that
already.

johannes

--=-t/GrD7snpEcPWI8lVJr/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0szGaVg1VMiehFYAQK3mg//QBX41wJYxiu/NmTLVcysUdoLElzE5JiI
SYNFk66sqQfXUiEf04bvSLOLqGgWE1+rFmJtrYBlYUCZ78EZzIOi09EKKf/ERlOg
lnWt3BUcbixNf7SWXkdXRENn/jbd43cSmTec4PFqADO9gSj/IbOJFD/l4r4cDifD
vUp/lA8XarpV/piaRlxbJZyQwXVIft8eZbJfvZQ6qZxiCmdJ068NIStl8/0A/NUk
sIHpIVXcK3OgGGirSygRvdjJoGN2TvMxG5qyYRwFhJpScDgclnAgYjL35ckiG536
QLfFW0xHOLwLL1TMc8NVuJu1jVq9oMDTgrordxPfXcf3dKUSiLqpqfMfSG7PEi7j
VkqzvTKKOo3T9OdKJRXJQUv6gNIxzpXU7DW8yXOWGYXaBzIWj7I7sXaPqjer+BgK
ABjAhuwTDLIQnL4wi3aOOwaNSrvYUMjb92In8U2G0vp04nAKnNjUkafVmJwXtHK6
tV6o60jclEEGLinupNrIuKjOrKiBWY5SaZWkb8sGJ19tiOCcGhSXRmX8oH9Hnz1m
Llw6oxJLGmgRLFuYrusIYfdxnXTyRFsselgC85mJlan9rdSP1achNEBv1hUqJUJb
j23QTX4skPbPZCZkdLS6jjfQFHwyRBqAaE841HyNWLW8/gnQA/TPn/zKe8HKOCsx
XJlcDJ1BeG8=
=aQKo
-----END PGP SIGNATURE-----

--=-t/GrD7snpEcPWI8lVJr/--

