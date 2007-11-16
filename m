Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46051 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757789AbXKPU43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 15:56:29 -0500
Subject: Re: [PATCH 0/15] mac80211/iwlwifi (#everything): integrate
	IEEE802.11n support
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindzonski <rindjon@googlemail.com>
Cc: Guy Cohen <guy.cohen@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net,
	tomas.winkler@intel.com
In-Reply-To: <c85cb4470711151036j11fc855fnfde4366c11df97b@mail.gmail.com> (sfid-20071115_183732_667665_6820BE15)
References: <11950541913679-git-send-email-ron.rindjunsky@intel.com>
	 <1195056662.4091.29.camel@johannes.berg>
	 <247d6d340711150233h7988220fifb0d34170d16a979@mail.gmail.com>
	 <1195142683.13846.62.camel@johannes.berg>
	 <c85cb4470711151006j765831f9w2fb941317153712c@mail.gmail.com>
	 <1195150317.8147.7.camel@johannes.berg>
	 <c85cb4470711151036j11fc855fnfde4366c11df97b@mail.gmail.com>
	 (sfid-20071115_183732_667665_6820BE15)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cPbCRAmhWRMGK/5CZpWQ"
Date: Fri, 16 Nov 2007 16:59:53 +0100
Message-Id: <1195228793.8147.153.camel@johannes.berg> (sfid-20071116_205643_996346_5986C91C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cPbCRAmhWRMGK/5CZpWQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Yes, getting the code into the development tree will be excellent.
> I am already working on the rx_h_data fix we talked about, and will sent =
it
> over early next week to wrap things up.

Sounds good to me. I don't expect anything much to happen until then so
it probably doesn't matter if it's merged until then or not, but hey.
I'm certainly willing to rebase any patches I do, in fact I'm sort of
waiting for this before doing another attempt to do proper band rather
than mode stuff

johannes

--=-cPbCRAmhWRMGK/5CZpWQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARz2+eKVg1VMiehFYAQJELhAAkDXhjZqcOeFgSbHdHonMtTP/diPsCpVF
drXtAkaAoxV9Fnd3mgu9pOv9qGyhFLwUA+wEvQNERG/uXbWDZH/sz0+JOnZH4rsf
/nes6cvsdC0e5bIrh8u2dYrYm+j4E360jV4WlVUC+drTZZ63aTJxT5xUl+S9uMcU
DcIlWKxaNz7wkmnaLS3/zbUBRiTpi6LUoAnaAYmXSao6fzDoW45A4gEo0SIVEa9Q
I+JFoielMAzIKtmp5MyiaR8M0bpPql3iYnS/+LATZmUKAFSuKdUt2eId3WnjKuec
icbD/HxbIEPQHB+vELwYlVpyi2ywD7wLWvwmD2cmR+B/3a0vJh2wEnVOQs0P+c8X
U6ZQCCBGfQC+uH5AP7rzh0DDv7wf/XC0HTsggSc8Iuwv1V4iGcqEn9oMg0xnPMC5
/LQCrZUYjsDXElm8I0H51P0BwjqVcINcaDHdUYOcnqc32ClzEcO+2zU1SM42K1MW
davrWQAVMI6zZ438crqDM6jjcnQjXR6FCDEZpYp9pbpJE+J2SSreAKfkpdEGCVVI
QbbfY/KkEZGPeBzVWXe7Vz65B1NpV2bm9s7p/NnOiqAPddJYPOtpWzTTUyZaFf/G
65nezxxm6sqO01bO2DLRBy3NXeXVfXoVxu+TmdTUZ/Ha4X6W8lLor3W3JFDfF/5j
lBaCvpv2PXA=
=9n6s
-----END PGP SIGNATURE-----

--=-cPbCRAmhWRMGK/5CZpWQ--

