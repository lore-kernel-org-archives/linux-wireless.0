Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58917 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757553AbXIFMLO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 08:11:14 -0400
Subject: Re: Kernel panic with rt2500pci built-in
From: Johannes Berg <johannes@sipsolutions.net>
To: Rob Hussey <robjhussey@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <6b8cef970709052025w4885b075yc9cf79c9f7f6dd52@mail.gmail.com>
References: <6b8cef970709052006q43d5602ewde0cea45500deede@mail.gmail.com>
	 <6b8cef970709052025w4885b075yc9cf79c9f7f6dd52@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dWfQVh5qdYUlBzVp0UKa"
Date: Thu, 06 Sep 2007 14:12:34 +0200
Message-Id: <1189080754.28781.68.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dWfQVh5qdYUlBzVp0UKa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-09-05 at 23:25 -0400, Rob Hussey wrote:

> > ACPI: PCI Interrupt 0000:02:0a.0[A] -> GSI 22 (level, low) -> IRQ 18
> > phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 0201, rf: 0003,
> > rev: 00000004
> > WARNING: at lib/kref.c:33 kref_get()
> > [<c0229da9>] kref_get+0x3d/0x44
>                             kobject_get
>                             kobject_shadow
>                             kobject_set_name
>                             device_add
>                             wiphy_register

I have to admit I don't understand this. It seems that device_add is
called with an invalid device, but that's very odd because
device_initialise must have been called before.

johannes

--=-dWfQVh5qdYUlBzVp0UKa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG3+6y/ETPhpq3jKURApFlAJ9R8LyURAp3vbAdwY8XkBHJuKNHewCeJWLO
q8U0OxDI/2uf1OW20y9gAVs=
=S+jr
-----END PGP SIGNATURE-----

--=-dWfQVh5qdYUlBzVp0UKa--

