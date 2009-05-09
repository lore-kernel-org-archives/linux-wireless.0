Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39357 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbZEILAG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2009 07:00:06 -0400
Subject: Re: Warning when terminating wpa_supplicant (wext driver)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <43e72e890905081823w2087e84aq3294ae1461e75b38@mail.gmail.com>
References: <1241677107.2918.4.camel@localhost.localdomain>
	 <1241696104.27208.2.camel@johannes.local>
	 <1241704437.4903.15.camel@localhost.localdomain>
	 <1241705979.27208.31.camel@johannes.local>
	 <1241827331.4903.75.camel@localhost.localdomain>
	 <43e72e890905081813r58888509je62856008cc62d22@mail.gmail.com>
	 <1241831891.4903.80.camel@localhost.localdomain>
	 <43e72e890905081823w2087e84aq3294ae1461e75b38@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-2QXEDqcsq7/m1mbyqoOR"
Date: Sat, 09 May 2009 13:00:02 +0200
Message-Id: <1241866802.30488.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2QXEDqcsq7/m1mbyqoOR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-05-08 at 18:23 -0700, Luis R. Rodriguez wrote:

> From the looks of it the intel hardware doesn't want to stop the
> aggregation session which is API-breakage -- which is why you get the
> WARN_ON.

Yup.

>  This is happening when you are disassociating.=20

Exactly. But not always, it seems.

> I have a
> feeling johill's other patch will fix your issue but regardless I
> believe this just highlights more we should flush our queues (both RX
> and TX) before scanning.

It might fix the disassoc, but I don't think it'll fix this issue. Might
make it disappear anyway though.

johannes

--=-2QXEDqcsq7/m1mbyqoOR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKBWIuAAoJEODzc/N7+QmaVlQP/3PYil2efbVsWsghkCE2cRcY
tvj0qEb6kWA4tsJdQsXbj0CPEjB5wl1rCGBQcR6NRL9ZRiVjoeJdeY0i33B9AUD2
t2Q5Z3NfQKmRtSXq6UzGlU08IgiF36IDH7XxV5cmrrjaw5xYdr+js6zR/hKS2Dwl
Q87+jPMQ9/50R20xc9HgsnE0RITH8IUyVx0eX+pVN3OMgM+0qsww3aZdyG5GmX/m
9Yjbsnz84ugYOoaJ5tTlJOyl16d+TszvZyTBT+yPnUs8lUoI9L6guNYDkSXLD7ja
Rj4voHme0Kbc0q8oIJ+75aMIxsPJ8nDAsX2yFZVxiT5GNdy/GUJdrfghlumrV1Rn
GZnzNEVxL/m5I7dmEWXtXMe0XJooVRDuiWq6QEg4pmMfKhzQpURUuKgbnPBdYodM
30p8ABW33nVnFDyOHjXM9rp2fdkgib0GQoThtEY1xmW+XXad+/5cH9aWx2y12QCd
89v03X91dKu4w37OmWFus9mETm77EFOPJpcW8Q3dECkMxPUV3XVfLUal1oM19Py8
3AaAaiFZzmRvNS089oV1A4TFRdJn645uxaTSb6EWOtthvSob2/76GA7pD/Rt17tS
Zr3EVinjMVhIxGgVe9TBMNIxkEFJZ9bzVOIx5TCLJnz8gs0EL1G+DsWmKAnQ+lGv
8KuRuQN7Ux306XRU0o8h
=xHCy
-----END PGP SIGNATURE-----

--=-2QXEDqcsq7/m1mbyqoOR--

