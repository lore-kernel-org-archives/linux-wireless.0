Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38801 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbXJ2QJG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2007 12:09:06 -0400
Subject: Re: [FYI] hostapd state with mac80211 on linux
From: Johannes Berg <johannes@sipsolutions.net>
To: Guillaume Chevillot <guillaume@chevillot.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	hostap <hostap@shmoo.com>, Chuck Tuffli <CTuffli@dspg.com>,
	Alexander Kotelnikov <sacha@myxomop.com>
In-Reply-To: <20071029125541.GA4304@chevillot.net>
References: <1193338400.4406.4.camel@johannes.berg>
	 <20071029125541.GA4304@chevillot.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-x7zYZqrxaNmLnER1RrMR"
Date: Mon, 29 Oct 2007 17:09:32 +0100
Message-Id: <1193674172.5197.73.camel@johannes.berg> (sfid-20071029_160909_430698_5776A389)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-x7zYZqrxaNmLnER1RrMR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I tried with a kernel downloaded from git (so with the netlink commit
> already merge into) without success.

I haven't tried really.

> Some code of the old interface has been removed so I had to apply some
> of your patches manually and tried to reinsert the removed code to be abl=
e
> to compile. I did this quickly so I suppose I forgot to re-add some
> code.

Which patches? They currently all apply against the version of linux-2.6
I'm running. Or are you talking about hostapd?

> So I think, you will have to do one more patch for the rc2, ...

Well, I'll obviously keep maintaining this series until it can be
merged...

> Tell me if I am wrong, but your patches "just" keep the old interface,
> master mode code and others previously removed. So, new code will have
> to be done to re-enable master mode and a driver_mac80211.c (rather than
> a driver_deviscape.c) will have to be done for hostapd ?

My series has both re-done and old code.

johannes

--=-x7zYZqrxaNmLnER1RrMR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyYFu6Vg1VMiehFYAQIVARAAr9z+KWVz6YJGWofLKCYEZNQtrsl+RcOC
lBEY63elaIaHHjFoMe6Fxsf6ygbzQnUqtndVMURZzX5Vft3s+10k/zCKrINKxWjj
3ZzxArsb3rHZPctf261lnok6RW6dagnxoXqLvCMljZM+ite8xmGbFLpUF5IIMPAH
pogy/OFL5kF9w4IIP8rcrd6LQRcz7w5zBKsXI8bhNcnxzKrnmeEZp3ePXThKEpeZ
h3A+74uqX5pLOGl3SdUtIWq2gq8Ne3G087FuH1KfD2YXqCLq5fjH+uatM5dlt9fP
34vdQWX5SXZOXmde+PdWv/SlBLP5Z2WHPjcLd2KAMG6TlY0HW6PHTxMuod87m68x
CX/szujRFbKogBhweDdtV211HrYPvnKvB3V7LmVmzOKuyKXcz7q+Cq8XGF61Ju/j
RexYsxU90YkR7OHcfAXEPOxIg5HggvWambmbZtkL9hHv+TkKHEfmMBEiqGN3GPMh
GihHDKzxcBPgJUfxDERWTtvTXSoAkbqbdR4PetAycp64csP4jGb921LOSCx0BN5U
HcWVWQevjH5b5Ff1ngBfe4u1bzOQnTRGNhwR6NWZxDxhPu5OR5mmZODjAdgaHKat
wpE0ZCkB0WXeuXYrrTAd7Tv4fN9NgxN+ezmcqUrUFsAlQ8GATlwCvYBUZrl9SwAe
yWmMiJroCaU=
=y20Z
-----END PGP SIGNATURE-----

--=-x7zYZqrxaNmLnER1RrMR--

