Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45900 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbXH1QaA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 12:30:00 -0400
Subject: Re: [PATCH 08/12] mac80211: remove hostapd add/remove interface  ioctls
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070828161453.266899000@sipsolutions.net>
References: <20070828161346.972115000@sipsolutions.net>
	 <20070828161453.266899000@sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2bSKafAiUTaBz++mkoiL"
Date: Tue, 28 Aug 2007 18:31:24 +0200
Message-Id: <1188318684.7837.110.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2bSKafAiUTaBz++mkoiL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-28 at 18:13 +0200, Johannes Berg wrote:
> plain text document attachment (014-remove-hostapd-if-ioctls.patch)
> hostapd no longer uses these ioctls as it uses nl80211 now,
> so they are no longer necessary.

That patch hasn't been merged, but no driver we currently have actually
supports WDS or multiple BSSes which is the only use for this right now.

johannes

--=-2bSKafAiUTaBz++mkoiL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG1E3c/ETPhpq3jKURApkVAJ9Vg7uRbLGew6zmUgzj5a3mxw7R5QCgq4Ko
lM3bPQj0lviHmYqGpi3t2Ns=
=e23y
-----END PGP SIGNATURE-----

--=-2bSKafAiUTaBz++mkoiL--

