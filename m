Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59188 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679AbYDCNgU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 09:36:20 -0400
Subject: Re: mac80211 -- My log files are filling up with: "wlan0: RX
	non-WEP frame, but expected encryption"
From: Johannes Berg <johannes@sipsolutions.net>
To: Miles Lane <miles.lane@gmail.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <a44ae5cd0804030632u71a2fa64nbea8fee493df56da@mail.gmail.com> (sfid-20080403_143236_671031_B110D27E)
References: <a44ae5cd0804021732s6ae5ed81ma5e229ae0faf4aaf@mail.gmail.com>
	 <1207226756.3636.66.camel@johannes.berg>
	 <a44ae5cd0804030615n3c3e906ey1db4513802bdf01@mail.gmail.com>
	 <a44ae5cd0804030624u40be9ad9rb1cadefadb13f889@mail.gmail.com>
	 <1207229407.3636.79.camel@johannes.berg>
	 <a44ae5cd0804030632u71a2fa64nbea8fee493df56da@mail.gmail.com>
	 (sfid-20080403_143236_671031_B110D27E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zLl/vO9M4v4pG+3L7cIM"
Date: Thu, 03 Apr 2008 15:36:15 +0200
Message-Id: <1207229775.3636.84.camel@johannes.berg> (sfid-20080403_143622_732980_65FD6630)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zLl/vO9M4v4pG+3L7cIM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-04-03 at 09:32 -0400, Miles Lane wrote:
> tcpdump: verbose output suppressed, use -v or -vv for full protocol decod=
e
> listening on wlan0, link-type EN10MB (Ethernet), capture size 96 bytes

> 09:30:40.477051 IP whirligig.local.44350 > 209.62.187.17.www: F
> 81705605:81705605(0) ack 1667952741 win 137 <nop,nop,timestamp 1348464
> 2231439000>

Uh wait, I shouldn't be seeing this if the network is encrypted. Is this
really a dump from the monitor interface?

johannes

--=-zLl/vO9M4v4pG+3L7cIM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/TdTaVg1VMiehFYAQKlABAAlgE8LjH6aeqI3SBP/ZRj28qdMHAXUJZR
iLL2sLAK/+E/2Ulet1tMyRi95DECU2Wfo/WURmV+9qXHpTGMRnRQPgZnL7HSUHlx
xO+YVEQeT4nP/7YCrf0d4ZmhsgMWEpD7c0U+QnAysA4C151Pm2Dowu62YWEAta79
uIk+iPMQtLF55f1JJFZxcQqaXTW3sLBFjaSE5i2x+mZteD5DPftOUHMS2mU2eV/G
GLDtYxpRPgdVM+/kMqETXToX6RW6ButVJeNqRiBRfVSHT8PYpjcgH0BfpxWqcTXk
J2TaySZruIm3xS/9TKxKeFWW9B5JOOaY+exqjkl0tkrkzruZPO4gWdiXtTPXWuAW
va8vFgoVmtchdE8lvKLLd6svtOp2d1V5yG1yEMtCXa9xSWvHGp4DTRKPB42E7t35
r+x93JGwvnHMKeJfS3rpx+85pCJv3UQuj5sM1/y1fqwXluJ0guuijheMa1LhpjsK
cJ9PvVAGFJ8/k1Zi/szPmmSpe2+4XWAXl4krNGWATXRvnhrNPu8qczrEXxI2DCvJ
hBW5daizXVfsXBYVN1OOOT4+NDGUyqoCOudnIJH+5DFH0LhEh2O82I0QXuYN8num
ilGZbxSUDwitA0jXWBNJOj9pDGGuRtjbqlf/hkGpkL2Ogw9ky3sDtHF/3KsuKJbJ
5aV42YzYZsk=
=Y1bx
-----END PGP SIGNATURE-----

--=-zLl/vO9M4v4pG+3L7cIM--

