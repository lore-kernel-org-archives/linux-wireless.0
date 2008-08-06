Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356AbYHFPXE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 11:23:04 -0400
Subject: Re: [PATCH] rt2x00: Add module parameter to disable HW crypto
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200808061727.32096.IvDoorn@gmail.com> (sfid-20080806_170309_878399_01725CE3)
References: <200808061727.32096.IvDoorn@gmail.com>
	 (sfid-20080806_170309_878399_01725CE3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-N5wRpVB9qpezx5Y8fxh2"
Date: Wed, 06 Aug 2008 17:22:25 +0200
Message-Id: <1218036145.23048.8.camel@johannes.berg> (sfid-20080806_172308_999842_7996C6B7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-N5wRpVB9qpezx5Y8fxh2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-08-06 at 17:27 +0200, Ivo van Doorn wrote:
> Add a module parameter to rt61 and rt73 to disable
> HW crypto. The option should only be checked when
> determining if the SUPPORT_HW_CRYPTO flag should
> be set or not.

I wonder if instead mac80211 should have an option for this. It'd be
trivial to simply not tell the hardware about the keys.

johannes

--=-N5wRpVB9qpezx5Y8fxh2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImcGuAAoJEKVg1VMiehFYpMkP/0vZ8y6mgdSAstGRCHIAqqpo
iRV53ebC3hCO07oKyvrYA4iVwGSrYI+lo859hc3DSemRuM3G2hM19tJdfW6xZee6
9scyEaZoTXVlSRLt8Haj/0btm71LrdBOamv9RdB4Hz3EJkhU8MXLL8+bqsfRfbt0
z4i2QHxJkF4LrZ7+P8SUBIZ1clvOXElZ18XF42qFpSs8j7LfKXz/wExhTDvg5lKM
NkpQq7SINJU8tv+MZKy8VVmZxkhJN8YAhS0x+023DemEkfL4a6aCBrax2pAlHvFD
P28VkSrQkA1a/edI8FBaCPQEa/VdMb5lhwTRb4kxTdHcxJ6Gz8ipp5542pLiSuOG
4GgINBrMO404qyjPkd1+ZAXeDaePwKh+fg7TrENXj6yNi0wX41bi/+Bc5vT+So91
5XAZ+3WfyuBuEzX4WkNPC5zKNMm+J1GMEuiOO565rklQ6DAifkAWRCX0hwoG9V5W
3yF0wqo611DObOO50xEZEY5KtKQZ1Lb8zPAYSNszDiyCn+NmmLRtz7I17hvMJbK5
38qp0P/LsaKLTgJ8xN+vR68dSb+22bJZENInOInqCqYRcm6ps0wF97BTMaFBc0Mp
BPbK1yxPI9ePwtMiaMznyD6dtawPH9F8a0pzGfBLzfBU+RvtgbIqKnaunb4NARFo
lzwlEzKEm/INUlf4nAuS
=OoEN
-----END PGP SIGNATURE-----

--=-N5wRpVB9qpezx5Y8fxh2--

