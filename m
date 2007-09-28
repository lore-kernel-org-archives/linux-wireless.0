Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from durandal.kismetwireless.net ([199.201.145.179]:34400 "EHLO
	durandal.nerv-un.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbXI1Pdt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2007 11:33:49 -0400
Received: from localhost (durandal.nerv-un.net [199.201.145.179])
	by durandal.nerv-un.net (Postfix) with ESMTP id AF90FBC0D9
	for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2007 11:19:25 -0400 (EDT)
Date: Fri, 28 Sep 2007 11:23:17 -0400
From: Mike Kershaw <dragorn@kismetwireless.net>
To: linux-wireless@vger.kernel.org
Subject: add_iface controls
Message-ID: <20070928152317.GA7387@drd1813.lan>
Reply-To: Mike Kershaw <dragorn@kismetwireless.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Sorry for the mostly-usage-related question, but I'm obviously missing
something simple - after a week of searching list archives and git I
sure can't find it though...  What patch set is required to enable the
mac80211 vap add_iface/remove_iface controls in sysfs?

Running 2.6.23rc8 I can't find any mention of them in the source (and
they don't, obviously, show up in sys), and pulling John's git tree
yields no joy either - can anyone point me in the right direction?

(Symptoms are nothing in sysfs under /sys/class/ieee80211/phyN for
add/remove, and no __ATTR entries for add_iface in wireless/sysfs or
anywhere else that I could find)

-m

--=20
Mike Kershaw/Dragorn <dragorn@kismetwireless.net>
GPG Fingerprint: 3546 89DF 3C9D ED80 3381  A661 D7B2 8822 738B BDB1

Bus Error at 008BE426 while reading byte from DEADBEEF in User data space


--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFG/Rxl17KIInOLvbERAnKYAJoCJ0EBH2karoKfWnzOUxWI4zkafACfXm9U
TgCgxcLT1AgxbPk76rAXAVc=
=YveU
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
