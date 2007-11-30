Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44794 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbXK3LfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2007 06:35:25 -0500
Subject: Re: ZD1211RW unaligned accesses...
From: Johannes Berg <johannes@sipsolutions.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	Shaddy Baddah <shaddy_baddah@hotmail.com>,
	David Miller <davem@davemloft.net>, dsd@gentoo.org,
	kune@deine-taler.de
In-Reply-To: <20071129234327.GA23769@gondor.apana.org.au> (sfid-20071129_234339_196157_36CABDC6)
References: <20071120.040546.222294375.davem@davemloft.net>
	 <47442BFC.8090008@hotmail.com> <20071124150216.GA28153@gondor.apana.org.au>
	 <20071129214533.GD32730@tuxdriver.com>
	 <20071129234327.GA23769@gondor.apana.org.au>
	 (sfid-20071129_234339_196157_36CABDC6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VxnZnbr2cjTv3E47Cbie"
Date: Fri, 30 Nov 2007 12:33:47 +0100
Message-Id: <1196422427.6058.179.camel@johannes.berg> (sfid-20071130_113529_093190_9D7397B5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VxnZnbr2cjTv3E47Cbie
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Chances are it does make progress however we may still have the
> general wireless/IP stack alignment issue that we are still discussing.

Yeah, it's still on my list. I'll make a patch to WARN_ON unaligned data
in a packet... although this is a bit complicated. ath5k actually had a
bug with this where they simply ignored the hardware-added padding in
QoS frames initially which would result in "corrupted" data...

johannes

--=-VxnZnbr2cjTv3E47Cbie
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0/1GqVg1VMiehFYAQK+/A/+Il9sZxzucdZFTVbKM5G0oZHwos/UxvGf
wqsNzdC+EeqxmpG2MzbogI8mZD5xXIqJ3d483+2WktOKWOFQTiaBxDbLxx6XlxnO
B3PJyWBr2WmW/eM8PHZehVpBPB2Mx6IhxSLYbe1Ux7VbrjzlOIpbJAK0YmZjrD3C
CbOOAg5wWmpbI0oLs7ySEy2LxWteA9ZdIfDRNy49lwl6dT9ApXJxcOP5JNeFHEtn
Y+OshIWyXqAfRIuH/O3jz6hTLiBgYxE8OAduP00dBKQCWw9hA06HNvDrZcZSwhPE
LSo5KGPljWvAv3MvTCtZQNl28cU/slhFisf9TPA4p8eLVuwss5K26TscStIw3ep2
9zMxLNeDATDMTD1ywqTh82lshGlCJuJhEAVJCYBCJZwJPsQZdK++WvhizHQfnzcG
0vjs2RXMvwVMwEdiyV6cSGGmPSI7ih3W0CptJiEcOODn6g6Q/veJg447q6m70HLl
eND+WEo1STftHRSDmNmce+KV7h6rZkvKUdHnvLHgkjrKOwzxX4ExAT3SHGjaib6k
oCYC00nsHEh88iZFmiFAwKZBCAAyjMxG36EBkDfjCNcrsih/TKzQtKHPs3hQVKUn
Fw8wZyo0wlkjqg5tvPtq6ZtFc7dbaTfIBeyyvLyAI467ei9yHyUwYi11erq35fNQ
zne2AyReIfQ=
=d+S4
-----END PGP SIGNATURE-----

--=-VxnZnbr2cjTv3E47Cbie--

