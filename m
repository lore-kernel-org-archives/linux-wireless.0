Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55921 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZIXHxW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 03:53:22 -0400
Subject: Re: BUG: can bring wpa_supplicant/mac80211 into a stuck state at
 will
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org
In-Reply-To: <200909221123.36953.hs4233@mail.mn-solutions.de>
References: <200909211259.45431.hs4233@mail.mn-solutions.de>
	 <200909221123.36953.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-wNpJbrDCj+DnS+iArtM7"
Date: Thu, 24 Sep 2009 09:53:23 +0200
Message-Id: <1253778803.3868.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wNpJbrDCj+DnS+iArtM7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-09-22 at 11:23 +0200, Holger Schurig wrote:

> Maybe some state isn't clear at the implicit "ifdown XXX down"
> that wpa_supplicant does when terminating?

The SSID is kept and then re-applied during ifup, so that would cause a
scan, but shouldn't cause any timeouts.

johannes


--=-wNpJbrDCj+DnS+iArtM7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKuyVqAAoJEODzc/N7+QmanLAP/2fKTUimbnL7FO3RivE0cUQs
ucA+PF6LgijR4+7BKzNHr9qC7TAjPc55flynr0fBrDUT5XPZrFRoxQYLzw+8f2p5
ZiNYIhxrxq5BGXBXZasWRGEaHSsD152zuYzCe1lOzTa2maMfVeO4wVfBnp9oy8ne
ygr8AfwmwSCGYcoPDwMQPi7Ac8XJbGuIRxgyi6DHtVMAH+M0U/MVzdpGD5VbBrUg
FQe8HTuSuaiah/TwdByr08TCmdWZ8kP54qqsKjxc16wET4T4jm5JfzSbiRDt6oo+
Nff+Z8kBSlcdsUInF7ky5Cnl3rA43GKlOSSIm9wlEQMHDGX4krpUXfK3UHrf6CAZ
2oFdlBWpGhoGY4OdfRU7X+puqZSwGrHPCWv7qdPC1FKYF/aCA5Emy2AsEvIbLzMf
LBCmbZLyWl48MHOxDlfzPyNco1NKNRns+uYUUh7TPc2DMbf6bNMY5V0iYSwKDGiP
T7DvR1qPkGRtH7kWFTrG6zEOEm0T6720WyTBk3/gBSk2S+K1CJjaCPz0wgqQns+D
CV7GRRX5/pGFlJq5EQdI2X6qhX/Futeub0SJ0qJMZLukQIYA+hdiPva0J2LKf7Oj
ScDFZQWo7e4aRFnN+KurA4Cj4clh7L3FFh1qGp6EVh8KumCKFRONE3N8zfB6xdB5
VmDOW/DmjgUZQJtRT+Vi
=Pm5g
-----END PGP SIGNATURE-----

--=-wNpJbrDCj+DnS+iArtM7--

