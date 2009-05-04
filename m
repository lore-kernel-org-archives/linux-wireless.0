Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58242 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087AbZEDQzU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 12:55:20 -0400
Subject: Re: [PATCH] add support for showing power constraint IE
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241455848.2903.18.camel@localhost.localdomain>
References: <1241453167-3720-1-git-send-email-marcel@holtmann.org>
	 <1241453408.8683.53.camel@johannes.local>
	 <1241454909.2903.17.camel@localhost.localdomain>
	 <1241455125.8683.60.camel@johannes.local>
	 <1241455848.2903.18.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-wKs4UJs9HONtNNgJNHi1"
Date: Mon, 04 May 2009 18:54:48 +0200
Message-Id: <1241456088.8683.62.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wKs4UJs9HONtNNgJNHi1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-04 at 09:50 -0700, Marcel Holtmann wrote:

> just re-based and added the patch for the WPA/RSN length checks. So we
> should be good now in this area.

Thanks, applied, and really pushed out now.

Do you think I should cut a new release with all the shiny new parsing
code, or will you work on more :)

johannes

--=-wKs4UJs9HONtNNgJNHi1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/x3VAAoJEKVg1VMiehFYlzgQAL1hKnFCnwa6XLLTtVyGgfBD
wfrFlrkRsySHJWMQTHN75Ti26HXClZFKWxfQhPoSwJlE2bhU7Txo2goAq5RfWXOb
AbqrTupsej/OelnHXj4Q3R+7P9ER5qg2FBlBLeAHs8X4+dre7UclzN/ShESufgnE
eKLlyVIifvzA2pvU9p4TaUaRXynpGcCEeZB/KFJaDoqVhGAXyZhKWz/pJJD8iBy3
+26gG2t82FOmTIl5PktG7G1cbfYC+Vf5KU3LV6f0MMvXlq7jrTPRjRklFTTyJN0G
VuAHb3qF3DdyWcjSUPHkOtz8wwjh6k5U1PmlUdMG3BvSc4Q0ngknlzYGnHTwN9wA
puH1KCrEswiTa5Y0IKl/dpsxLMUFLOr/kygY0ABsBqVvC9CU1NjXWaABAbISyXjQ
uECcVVJ3zY6r68Zd0Z9CDDMs6y7u64762yVIVWiEg/augzR05LXLSwy5vOecWqiJ
P7Lopa5o86CAlWNDYJTNeba6W8EfzgyfklTCAEil6yTUhghjTqMJMKbx2qIc/SI1
erKLNkUjjMXkKv87kRTAmiQVfYf2CD/EjfXIFDdbH61z+D4eoFEOqQs5jP+LT5yC
ew2Q7XSoC/gaPSPc1VdBFx7GyQ9EIZM3Ep+J1HhObEF4b+VZ8Cwoo0hAtCVbQDpd
z16NsAH85gMMgk2WHpA5
=w6cg
-----END PGP SIGNATURE-----

--=-wKs4UJs9HONtNNgJNHi1--

