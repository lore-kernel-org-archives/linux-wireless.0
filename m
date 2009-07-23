Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from durandal.kismetwireless.net ([199.201.145.179]:44828 "EHLO
	durandal.nerv-un.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbZGWEgY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 00:36:24 -0400
Date: Thu, 23 Jul 2009 00:27:36 -0400
From: Mike Kershaw <dragorn@kismetwireless.net>
To: peter meng <mengsanshui@yahoo.com.cn>
Cc: G?bor Stefanik <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Is there any wireless catpure tool on Linux such as omnipeek
 on  windows ?
Message-ID: <20090723042736.GC5616@drd1813.lan>
Reply-To: Mike Kershaw <dragorn@kismetwireless.net>
References: <69e28c910907170637k6b610d4fgb0566f7148e33b4e@mail.gmail.com>
 <916941.64319.qm@web15704.mail.cnb.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GPJrCs/72TxItFYR"
In-Reply-To: <916941.64319.qm@web15704.mail.cnb.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--GPJrCs/72TxItFYR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2009 at 11:28:04AM +0800, peter meng wrote:
>=20
> Hi,G?bor
>=20
> Thank you very much .
> I ran Wireshark Version 1.1.3 on Fedora 11 .
> Running on Linux 2.6.29.5-191.fc11.i586, with libpcap version 0.9.8, GnuT=
LS
> 2.6.6, Gcrypt 1.4.4.
> But I can't see any beacon frame when capturing .
> Could you explain it ?=20
>=20

You must set the device to monitor mode first if you want 802.11 layer
captures.

See also:

iwconfig mode
iw
kismet


-m

--=20
Mike Kershaw/Dragorn <dragorn@kismetwireless.net>
GPG Fingerprint: 3546 89DF 3C9D ED80 3381  A661 D7B2 8822 738B BDB1

If you can keep your head, while all others around you are loosing theirs,
then you must be the one holding the axe.  -- Anonymous

--GPJrCs/72TxItFYR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEARECAAYFAkpn5rgACgkQ17KIInOLvbHbRACgpYO6DB2x+3GluPs/chHygyom
rdQAoJxL35kZ6p9u5L8mIFgMRB6tqdnA
=eziy
-----END PGP SIGNATURE-----

--GPJrCs/72TxItFYR--
