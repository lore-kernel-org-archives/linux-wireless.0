Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36054 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbZFWLYb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 07:24:31 -0400
Subject: Re: [PATCH 1/2 RFC] cfg80211: connect/disconnect API
From: Johannes Berg <johannes@sipsolutions.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <20090622170409.GB30147@sortiz.org>
References: <20090622170409.GB30147@sortiz.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ioaJZeyJ7U4Qo3kuTp/e"
Date: Tue, 23 Jun 2009 13:24:32 +0200
Message-Id: <1245756272.4184.43.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ioaJZeyJ7U4Qo3kuTp/e
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[  176.185771] WARNING: at /home/johannes/sys/wireless-testing/net/wireless=
/sme.c:46 cfg80211_connected+0x149/0x150()
[  176.197900] Hardware name:=20
[  176.202752] Pid: 468, comm: phy1 Tainted: G        W  2.6.30-wl #71
[  176.209012] Call Trace:
[  176.218526]  [<ffffffff8024ae93>] warn_slowpath_common+0x73/0xc0
[  176.219258]  [<ffffffff8024aeef>] warn_slowpath_null+0xf/0x20
[  176.219966]  [<ffffffff805a58f9>] cfg80211_connected+0x149/0x150
[  176.221854]  [<ffffffff805a5136>] cfg80211_send_rx_assoc+0x96/0xa0
[  176.226272]  [<ffffffff805b28ec>] ieee80211_rx_mgmt_assoc_resp+0x71c/0x8=
a0

johannes

--=-ioaJZeyJ7U4Qo3kuTp/e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKQLtsAAoJEODzc/N7+QmaH/0QAIHIZQdKstHSZip5hndN60GM
Q5s8Hy13ZuNb6ZIOuFck7zEKiEn3GBVe+qJ8MhqixL7oB8fgF+uc3euwdK9EhCpI
R4t4lT+TNsIcxFX+zDSn3JFd+ppQrJV/t0jsyQooDrlP60u5XUghZVrl7bThqHL4
JHn82h3uhAtlTT+tGgtPkRrIVU5ZwsVWblX+eer4gWsWvjWlJHNPCM8T79QEkLDl
6kQP9sJEoJEdhY6tk38olcO99kG6hFKoJPxog97s1ezyOLvaa2IP3eUd0MMsI7Ar
fp62ljR6XGuGBzMspYRuWDCZsFR+cXYnq2T1V3/88GrDdFQK6mvBP/84oDxa44A1
pc75ULBmJeyhJag7rHwoPj76blGXSpeiHsD7yFSNKDnRgRiAy5dNnLaPaJPXGwSL
I+8pNzYQ6/nrxA/ciWEgduUGH4k/AbUAeJ/zDinn2dorBSn6VjkVd6JhQXHOtDrC
JjAn6Md4whMntWitBi2z8J3dAwejNtDLoYfOw/gg089B+d4lTeM+y7/XsXM5PWVb
QNqcRXgMVxYC/Vej9rz2hpdjQDfanxx3gFiDIKIbg9VWqCDE7/KMS0wZzjlpPlf4
C4pSmE01euJqjo0JGxSj3EctOAp/NWa2l2ZPgvrJjCZJX0P58nsILQd9FolEuvNl
t40Di5vyx9ww7DBEtOeY
=0V5F
-----END PGP SIGNATURE-----

--=-ioaJZeyJ7U4Qo3kuTp/e--

