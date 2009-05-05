Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45146 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbZEESuY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 14:50:24 -0400
Subject: Re: [PATCH] mac80211: report operating frequency rather than
 current
From: Johannes Berg <johannes@sipsolutions.net>
To: Richard Farina <sidhayn@gmail.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4A008649.1000007@gmail.com>
References: <1241452330.8683.49.camel@johannes.local>
	 <49FF2AE5.6040104@gmail.com> <1241460130.8683.85.camel@johannes.local>
	 <49FF2FE8.8010004@gmail.com> <20090504181357.GA19022@tuxdriver.com>
	 <87eiv49k6o.fsf@litku.valot.fi>  <4A008649.1000007@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-O9KfaQi1b0uPOQMfQYBX"
Date: Tue, 05 May 2009 20:49:49 +0200
Message-Id: <1241549389.4969.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-O9KfaQi1b0uPOQMfQYBX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-05 at 14:32 -0400, Richard Farina wrote:

> To be honest, I would be perfectly happy with this patch if something=20
> like a scanning "flag" were to be show in the output if that is what is=20
> happening.  I don't so much need to see the current channel (when in sta=20
> mode at least) as I need to know that the card is scanning if it is not=20
> currently on the channel the AP is on.  I'd be very happy to simply see=20
> it say "scanning" next to the channel or some such when this occurs.

Except that's totally not possible with wext.

johannes

--=-O9KfaQi1b0uPOQMfQYBX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJKAIpJAAoJEKVg1VMiehFYljYP/jrSFYl4eDXVDxdsGB++oZjx
KZ4kBqIBGabVzQhYuifLf2vKVnuvqDzR372y75k3ELrKru/NqgTc71TOC25U8KJq
nZhQFomeSrPEIeOj/yphj1PX2NcqnCSIW2zrjkX0NVPlED5lfYqzXXwqaQYgpVL0
En0H5479+oOz1QR1xQgJYhGg+VWYDq9+CgKH2pA9xRaNic5kaPSkQ8N8HuTeCptf
Wgjj1q9WSy5ps3lw/kGfDAfCVrNb+n2JcAwxkDN3+fbHDWvRov8wJ/eiKG+hIMMG
ok6PqzR+QAZGH5FK/erYmJAXzWuSkAkMiDP58KZv4jqze6bEMnncZecZhNrbcNL1
1Qh86d1e+zBHxROilZ1gEKuG4ztLZiIXJnP0QC40LK7B9XR+qvCZ6eJUeJlnwvlr
DolVDGk6rHLCRQ+GlPSAQnEWbIwZ4OXqvOyRTPaMY1LDyCiBhUAvjZCAy2cYjPSy
bP0ddhARnrr/9Dh+26yynwpUCU3ZGvqr8pOvEngpP6JoVR94D1I/ZxRYTSRGXyH6
LZOUfwBj5k0WxirxLrY9VDpA+WHfos2yKVlOWv2lHWJxhYhs8J/caMAawHTKpcCh
e85AIhc12wl1KopL+ZYvLaDjl+7za1Xzxr5Acrswzcgktpbwb6MD2Dq/S85NVSkR
vqGbG3HWwd3NZ88Nm4/q
=6lwA
-----END PGP SIGNATURE-----

--=-O9KfaQi1b0uPOQMfQYBX--

