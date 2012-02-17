Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from store.l.unchti.me ([88.198.247.169]:48770 "EHLO
	store.l.unchti.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab2BQOrs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 09:47:48 -0500
Received: from wlan0761.rz.uni-leipzig.de ([139.18.250.249] helo=spatula.l.unchti.me)
	by store.l.unchti.me with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <mittagessen@l.unchti.me>)
	id 1RyOaU-0005EK-AU
	for linux-wireless@vger.kernel.org; Fri, 17 Feb 2012 14:15:02 +0000
Date: Fri, 17 Feb 2012 15:15:04 +0100
From: Benjamin Kiessling <mittagessen@l.unchti.me>
To: linux-wireless@vger.kernel.org
Subject: minstrel rate statistics
Message-ID: <20120217141504.GA31438@spatula.l.unchti.me> (sfid-20120217_154751_064734_27DDCE76)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I know it sounds silly but I am unable to find the rc_stats file for
minstrel in my debugfs. I've been using an older kernel (2.6.35) and
recently ported a few patches to the current wireless-testing tree, but
after the upgrade there is only the rc_stats file of ath9k.=20
I followed the rate_control_add_sta_debugfs() path and couldn't find any
obvious wrong code. Is this a known problem or am I just too stupid to
find it?

Regards,
Benjamin Kiessling

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPPmDoAAoJECylO89uSo7HTgkQAJLunOJBx5BlmT2q8WWHyqmB
q9W20LVOpQ+7fU4D6MN94+DM3ik3RCtGOwt4CyweO3WddUQb78OToD9cE4rakQiw
fQ2dWePU86yXpWEL6dUp+UVUzu51frYYO+26TURcho2ENtKoS48vWASdVwHQCJZq
XR3Q7IpcoOnuY9RrEnO4nOzasA7/7rDWqX9m2WrL8tMOSfQKO7uTk6qN3tWIXDep
gw//DL8xqAxcX/uG7F0OZ3ZBiaCCfWECUa7Kv4XevUiNlQjsBFXsbmTQRSqQaOku
GJd/DO4TTq0rktKac+d9kaINYks2NcXkKs3SYboDF5HQ2BK7uOwn+uimOCKe0vHT
aLquNVln1NsMW0iL4ju2K6AUFz5RjVBp5MaLshnX1UV7fTqrDChIHw6sLzBSePm0
htPSaVBV3TtoTIaDl3kZ5R9jQJ+PNhhtlE+HfL29/Rw2uUxfPW8jZ4UL1H+8spqh
h5vydSmmibkQL5tOKeBKbSQAVGE/MORYrGUPFEkp2u9+QZF67HIibBDn234VKH5W
Fj3SvcS8Xi3KbsOrneWQV8m4spoSuTQ6Ur25tug/8xIHB/tK9F1Bd2MbOKMKf00p
NXJLP6v1krRQfqtI5Vpa2GiFXVBw8ULQgLo5Qz7LqxUz6e0QB0YQRN+o/H4E1dJe
P5AntJK2qUR8I6i/9zN8
=rp2f
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
