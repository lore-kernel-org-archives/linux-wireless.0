Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35559 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbZGWKjj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 06:39:39 -0400
Subject: Re: [PATCH 5/7] mac80211: implement basic background scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090723101411.5147.78380.stgit@localhost.localdomain>
References: <20090723100732.5147.73989.stgit@localhost.localdomain>
	 <20090723101411.5147.78380.stgit@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1GwNgaibuJjos4QqcdKe"
Date: Thu, 23 Jul 2009 12:39:07 +0200
Message-Id: <1248345547.19121.23.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1GwNgaibuJjos4QqcdKe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-23 at 12:14 +0200, Helmut Schaa wrote:
> Introduce a new scan flag "SCAN_BG_SCANNING" which basically tells us
> that we are currently scanning but may as well be on the operating channe=
l
> to RX/TX data whereas "SCAN_SW_SCANNING" tells us that we are currently
> on a different channel for scanning. While "SCAN_BG_SCANNING" is set
> during the whole scan "SCAN_SW_SCANNING" is set when leaving the operatin=
g
> channel and unset when coming back.

I think you got that description wrong :)

> + * @SCAN_SW_SCANNING: We're currently in the process of scanning but may=
 as
> + *	well be on the operating channel
> + * @SCAN_HW_SCANNING: The hardware is scanning for us, we have no way to
> + *	determine if we are on the operating channel or not
> + * @SCAN_OFF_CHANNEL: We're off our operating channel for scanning,
> + *	gets only set in conjunction with SCAN_SW_SCANNING

johannes

--=-1GwNgaibuJjos4QqcdKe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKaD3HAAoJEODzc/N7+QmamOQP/irQf8lP4mKl8C82Q+fODFt5
VLzs5g7fAF5Uzr1/Epn1R3Rc1tYxzvCPcBoWsaRg5jHNxSHPTLDjq+xVlkBCMb3M
OF+FIyeOnWrwg3XY1Gzvdm8b8SQtLav0NR2O+6gxJuDMMNJJtapnLSIBZIWNvLoB
7QOEY27A5wfmMyLYgPdLMj8+bkJKGfpjeOp2FtTcJ76QYn+n60ciNhi/Hw8wYV6Z
U+7C7qg92WM6oYeaoS733UhObXDCVkqqOQmiIbsZBWhZo2AFufwF1P9FdgwvdGjp
c3aRlIjZO0lLgTisAQCb4c3doZm8HtZVu5+DYelO7d9bjbXNk/NKAr4gs/CRY9Aj
UtzRDxA6rr52daM9SsGA4ev3foDwJQnuTMe4kyTSC6tW27U0URMD1QcP3OGzLv0N
zAEC99hGj/3Slu8xoGtZvNMwGFkPt1qCRdyu6TGJS/Ob05xAhkyrC6GSWg5LFR2z
9JV/MIX+5OamiyQrXlwBBgL4D8pYgXQ/XDaKd7TQHXDde5+gjK/MVgYp3oJE0ANA
ANDAphBvb987Vd/qRDfBOzpEqJMdoPTFFhuIJlWVxlg/e0rr+JfRUldvr7SEoNKt
YDfa3QFVoPTUfy2FVKADzEKU1lbS0CtIk4hG9aaZW5EpXiwVUUWq9chEg5SWHVFk
Fbxni1WJ2sV0nBkeY3ns
=X9Hw
-----END PGP SIGNATURE-----

--=-1GwNgaibuJjos4QqcdKe--

