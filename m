Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51115 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595AbZKMWVA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 17:21:00 -0500
Subject: Re: [PATCH 15/16] iwlwifi: handle unicast PS buffering
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1258150491.4182.6.camel@maxim-laptop>
References: <1258142198-3223-1-git-send-email-reinette.chatre@intel.com>
	 <1258142198-3223-16-git-send-email-reinette.chatre@intel.com>
	 <1258150491.4182.6.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-V253EkFim64gZasrGSUb"
Date: Fri, 13 Nov 2009 23:20:57 +0100
Message-ID: <1258150857.6167.28.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-V253EkFim64gZasrGSUb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-11-14 at 00:14 +0200, Maxim Levitsky wrote:

> Does this cover iwl3945?

No, and I don't know if this functionality is present in 3945 devices...
Maybe, but I think station handling is somewhat different... You can
test it by allowing AP mode, connecting a PS station like an N810 (good
test device!) and adding its mac addr with arp _manually_, see below.

> If so, AP mode would be possible?

No, because multicast buffering isn't working properly and I can't
figure out how to do it. John's patch doesn't work at all. And if you
want to test PS you need to use arp to add the mac addr manually since
the arps either don't or do go out etc.

johannes

--=-V253EkFim64gZasrGSUb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK/dvFAAoJEODzc/N7+QmaryUP/1EIEoGceJMAJ03llp7vO4pj
evnya53szzj1psTKmwD64Lvq9en/m7/BcB54KL0T37xdMKGTHZr+6StjrFvqRKr0
Rx7fMNg+EX3Iw93Q0OXGRMgSvPxtvgKnSzutnJ0w5QyMGL7/jpnBPRdIvfiCkw+t
XBixwiVtF03ZguxyAjxXG4cjvRksqaKAAxy4//ozK/g+4wh4Xho25aIauCUz/8dc
gAqf7avf0ONI37QkwRYFeDuIofzZ5u9TrsYh0Q8tJn6kSbs/xiDCV0mwluetAHFg
PxpUlO+jUCPUGbhroIPAfukFX+pJQCdz4m8Evt79tmOcVTeb4atlzd/ZFm9jp+nn
depXjC+4La7WQksfYLvRYNtvVmXPJTXAn92HuhZ6zE2TYu1mP2XePNGrrWE6s776
Or23v1Q5esgFcDaHThUyOcaF6zYHo+OxlJ4ZNkBOiGI3a9/2/den5mPXu06kEkF0
lE/dtOaHMU5S4gmhUDlDu+LojjkXvXH1wfJRqQ+3JmRVyDJParI0yaPpnMZh/t6g
cpW6+7YbVPKxb3qsrMLx5Vhbs8GaLTqV3o/F4pgJLlMMS3zBPd3ZzZpv9Xgbzp/N
b0qZXH7gB/sEp7jtVgAXBahhuKaCayZRG7ZXfAWiX3T/d9+ulha9y5ICOvjisROM
gipKmq7UWq+DbcvbMzv1
=7Xbp
-----END PGP SIGNATURE-----

--=-V253EkFim64gZasrGSUb--

