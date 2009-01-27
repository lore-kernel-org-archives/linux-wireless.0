Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59993 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZA0JiJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 04:38:09 -0500
Subject: Re: iwlwifi warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240901270134x50b4daej9fb600ac1d8311ef@mail.gmail.com> (sfid-20090127_103443_996284_47980106)
References: <1233047705.4012.12.camel@johannes.local>
	 <1ba2fa240901270134x50b4daej9fb600ac1d8311ef@mail.gmail.com>
	 (sfid-20090127_103443_996284_47980106)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fS1u/Wf0PUGNzpp9ddUt"
Date: Tue, 27 Jan 2009 10:38:05 +0100
Message-Id: <1233049085.4012.14.camel@johannes.local> (sfid-20090127_103815_151824_DD0DA7F8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fS1u/Wf0PUGNzpp9ddUt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-27 at 11:34 +0200, Tomas Winkler wrote:
> On Tue, Jan 27, 2009 at 11:15 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > drivers/net/wireless/iwlwifi/iwl3945-base.c: In function
> > 'iwl3945_pci_resume':
> > drivers/net/wireless/iwlwifi/iwl3945-base.c:6319: warning: ignoring
> > return value of 'pci_enable_device', declared with attribute
> > warn_unused_result
> >
> > drivers/net/wireless/iwlwifi/iwl-agn.c: In function 'iwl_pci_resume':
> > drivers/net/wireless/iwlwifi/iwl-agn.c:4128: warning: ignoring return
> > value of 'pci_enable_device', declared with attribute warn_unused_resul=
t
> >
> > drivers/net/wireless/iwlwifi/iwl-tx.c: In function 'iwl_tx_queue_alloc'=
:
> > drivers/net/wireless/iwlwifi/iwl-tx.c:302: warning: format '%zd' expect=
s
> > type 'signed size_t', but argument 4 has type 'u32'
>=20
> Patch already queued.

Ok, cool.

johannes

--=-fS1u/Wf0PUGNzpp9ddUt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJftX4AAoJEKVg1VMiehFYb14P/iHN9mBjDTOBmOn8zkQz1s61
ZP3cyAD6P8oVlA1SuggE96quzc3V9SxiV1j59tznLrTyVUcseDe03lJM65nrV+yG
dJU9WyGCLd70oVTu8iwDojOhYSGf4dDPiiWUW5w7Oyai4w3clBLvVujPjwqv8IIu
Kd+jW/YnRVcqIH6mM9yFky2bqKL1pxbvlAlQCsm4kI12+krHSsIaJN+gnZf+gO4W
zZPPJmABjhyEOZVKKs2TDHffYA6ee5mwnYuGOdvulp7JCOVAKAiaMLR27lsqBr0E
is9lRjAaLX6Wku5GiXbw62Em/8oSYDDFDqZVp4S5gzzYl9jEEiYwiq9uMpXpJ8dv
ggc0PXx1BIPn6GXKjVH7BZLRRYEyW9/MGTR8OpjkB7ze1Pe7W7WNkVIwOltPxtWm
FwyxSQfkX5Lxjpn9qapuwMRSBofFIJgRKEeRtA4myCSfC1/WJo2Tfnkd3FM4i8yJ
xe2NebMx87QR5FRiyE6OvxtGV8vqznhfzPctcW3iwfgLw888j+CaUmd2fm522QP/
2OTMwyDbxRyfvvJKrkOxQmBBDz9QuK2iP1K+shB5uuLBzfo++Y1OGpFRJnmqffy7
71JU/p5Jn+8XkuR1UdLfioS0gzo4DaH9k6itRb3CYjsmRnGkRP6ARVEjUuM2QZ+v
S5195mVpoMePLB4D6Xb7
=BSfS
-----END PGP SIGNATURE-----

--=-fS1u/Wf0PUGNzpp9ddUt--

