Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46060 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755096Ab3JMUG6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Oct 2013 16:06:58 -0400
Message-ID: <1381694812.1301.94.camel@deadeye.wl.decadent.org.uk> (sfid-20131013_220701_118145_00AD2AB9)
Subject: Re: [PATCH] rtlwifi: Add new firmware files for rtl8192cu
From: Ben Hutchings <ben@decadent.org.uk>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: dwmw2@infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Sun, 13 Oct 2013 21:06:52 +0100
In-Reply-To: <525494DB.2060301@lwfinger.net>
References: <525494DB.2060301@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-+yirvjXNNy2N54ByYvVs"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+yirvjXNNy2N54ByYvVs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-10-08 at 18:27 -0500, Larry Finger wrote:
> The vendor driver rtl8188C_8192C_8192D_usb_linux_v3.4.2_3727.20120404
> includes new firmware files. These were extracted from data statements
> in that driver to form these files.
>=20
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>   WHENCE                       |   3 +++
>   rtlwifi/rtl8192cufw_A.bin    | Bin 0 -> 16116 bytes
>   rtlwifi/rtl8192cufw_B.bin    | Bin 0 -> 16096 bytes
>   rtlwifi/rtl8192cufw_TMSC.bin | Bin 0 -> 16116 bytes
>   4 files changed, 3 insertions(+)
>   create mode 100644 rtlwifi/rtl8192cufw_A.bin
>   create mode 100644 rtlwifi/rtl8192cufw_B.bin
>   create mode 100644 rtlwifi/rtl8192cufw_TMSC.bin
[...]

Applied, thanks.

Ben.

--=20
Ben Hutchings
Beware of bugs in the above code;
I have only proved it correct, not tried it. - Donald Knuth

--=-+yirvjXNNy2N54ByYvVs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUlr9XOe/yOyVhhEJAQq/ZhAAjc/0Ed0hmNYpG2V5tziUz1i5DQh0U5TM
rFGnctlre4Uj5De/ss+2ubBP+IvLFIE0OfFq7K9KdygAci7tsW/ZSbrKriFpIep8
IrGs+mkeOm3ahQOKUIug2iKgahwTtFKhr/rZOMUpV1TalKSbWZg0EE2cUaI1rWak
CPaYbYTtDdpf2OC0svEmCgcTQ+rYHSETfBWiDpUrL8PwOytIRpSSndVKNMLPD2L8
N/v72/dV6hmQUQV3vHbf1Aw995UXSmjTxO8LR5meZl6QLi5sRjytbZFBLUelWj/K
f6h7ufzL7qdw8bVzBZdPoHkDAJOpNeEzsBuyiHUGinXrjHLB74UnsEEIahIRxZCI
eQ4h1eoBNcfwkR3pTRdrcMPDYiZvDoJlEtR87h64LdNo/cPHGaXHkVvEHIG0QR7r
4f0yASfcJotlPOgqf+/sAx+rd5tmIIb2fFAlj6yC83xcSXMBcWxVq05Ze9tSPxlR
KojUsaXGuGbhaPLgBGU3Lz+v9bGll2wLqS+f75h7T4wa0wBbTe96+1KbEbtAilw+
zpPcLY5fYGzzMxmb00xRu44FzavgBbrVnBJlvIyhnc90zkk9CexKR5C+C8kqgwBN
O9Mvsgyf1/8We2tssz0MX/TsdtpJxjxCE5XsyJL4ucfcg9rgIeAEBV0aR6WsOP9g
Hb3G9kXwJ/I=
=VH9X
-----END PGP SIGNATURE-----

--=-+yirvjXNNy2N54ByYvVs--
