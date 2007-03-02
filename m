Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42767 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423014AbXCBK6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2007 05:58:12 -0500
Subject: Re: [PATCH] mac80211: move PHY things to debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <45E80064.6000200@warmcat.com>
References: <1172774065.3381.3.camel@johannes.berg>
	 <45E72174.9060104@warmcat.com>  <1172775866.3381.7.camel@johannes.berg>
	 <1172776049.3381.10.camel@johannes.berg>  <45E7DF58.6080608@warmcat.com>
	 <1172830582.3482.4.camel@johannes.berg>  <45E80064.6000200@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yArWqeNRwdEAd70osFyD"
Date: Fri, 02 Mar 2007 11:57:18 +0100
Message-Id: <1172833038.3482.16.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yArWqeNRwdEAd70osFyD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-03-02 at 10:45 +0000, Andy Green wrote:

> But if there is a better way for the stack to get unencrypted broadcasts=20
> (that is all I really want, addr1->FF:FF:FF:FF:FF:FF packets) through to=20
> usermode, which you would think might not actually require hardware=20
> promisc on the hardware, then I am quite motivated to work on that.

Well, no, there isn't. When a station is in powersave mode it relies on
the access point to buffer packets for it, which it obviously won't do
with such packets as you're sending.

johannes

--=-yArWqeNRwdEAd70osFyD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF6AMO/ETPhpq3jKURAqgQAJ9WZWDWCpkrAZK35vD0taTrLi90GgCbB0YI
QpRpjWNeFJZ4a6CdzKg1c5w=
=fwvR
-----END PGP SIGNATURE-----

--=-yArWqeNRwdEAd70osFyD--

