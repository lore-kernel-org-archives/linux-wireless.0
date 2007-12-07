Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60699 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbXLGMsF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 07:48:05 -0500
Subject: Re: Automated kerneldoc for all wireless drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890712061538k10d806f8xbb7148b0de3f66ce@mail.gmail.com> (sfid-20071206_233816_263038_E7A018D3)
References: <43e72e890712061538k10d806f8xbb7148b0de3f66ce@mail.gmail.com>
	 (sfid-20071206_233816_263038_E7A018D3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FmkeAS8kMiSJ4AbCamaM"
Date: Fri, 07 Dec 2007 13:48:03 +0100
Message-Id: <1197031683.4171.3.camel@johannes.berg> (sfid-20071207_124809_409092_6413D7A3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FmkeAS8kMiSJ4AbCamaM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2007-12-06 at 18:38 -0500, Luis R. Rodriguez wrote:
> We now have automated kerneldoc HTML output for all Linux wireless
> drivers. We just need to the references to our wiki added, and that's
> it.


I have disabled it for now, your script output is really cluttering the
~wireless homedir. Not nice.

Instead of putting the <<kerneldoc>> macro on dozens of pages we should
also just provide a virtual moin hierarchy like maybe
linuxwireless.org/kerneldoc/<filename>.html or whatever to show it on
the wiki and then we can refer to those pages easily.

johannes

--=-FmkeAS8kMiSJ4AbCamaM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR1lBAqVg1VMiehFYAQKyjQ//XK/2H1PuqbwcjqNAtOzYNcMLBHy3Htc+
cYhwL7MNoQks7CkXbtdJHMtk6LkBjAjnGDRQS+QlOae9oTE/naOTH7ijOjJXH5ze
8C0DaLy5wsSlXmqTpqsB9WR9d4cAnMNhQFRU3zpFN7fgsVPEw+oBpCKSGPMIlBqX
q/nvSAt6iraWqXR/7oHYhrXnPCbNwts4wsbfLdkK06YlzguuoVKwmpRwWj/GkZ1C
9uwOpTFOTZs4xLExgQ3ClIhUHzT8P00vpyUoVL4upSKoEsc9klsGVgKUUEe4A4/P
4NYdea0DYSM9Ntl5N3i+BC3nFqlGeI1XteUleYSFquNkINPbKG+NL3BsG0EkzWI5
ySMX/vwl6D/rxNVFu6v6LSuSaDeVRiZMEFnOw35ZxOM/HlgZ4Idyf64gvgalIZJq
JFgtD+46JimrSsEi4hoPn9Qm9TSR/2J16wKEyGaS20O/AZqL22B7C2tBpTL4FFC4
bK0xNfaTSO48QKpe2Ap9q8KhX9vxhbZ7l/gEUYp61AQjDsC1EQ3jEddWht/HItjH
ZL4LQe2vmFgZ8IUKSvm9J9jWDehfHPSilQF+pJYMDvFw6sH0/+my2dXoWwc99pcA
SSsDaGnNT+BscqJE+hLNHQ5MNZuy3ex5wHzr+mcwUzrETBlhwpQP4MVuG22iFdW2
WGn1R45owD8=
=BXGi
-----END PGP SIGNATURE-----

--=-FmkeAS8kMiSJ4AbCamaM--

