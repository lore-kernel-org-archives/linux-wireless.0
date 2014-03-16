Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46373 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753281AbaCPSLK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Mar 2014 14:11:10 -0400
Message-ID: <1394993460.15764.89.camel@deadeye.wl.decadent.org.uk> (sfid-20140316_191115_409692_28A92FE6)
Subject: Re: [PATCH] brcm: add firmware for the BCM43362 WLAN device
From: Ben Hutchings <ben@decadent.org.uk>
To: Arend van Spriel <arend@broadcom.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	David Woodhouse <dwmw2@infradead.org>
Date: Sun, 16 Mar 2014 18:11:00 +0000
In-Reply-To: <1393014109-4712-1-git-send-email-arend@broadcom.com>
References: <1393014109-4712-1-git-send-email-arend@broadcom.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-t9i5vZRKg7wP4robzs+D"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-t9i5vZRKg7wP4robzs+D
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-02-21 at 21:21 +0100, Arend van Spriel wrote:
> This patch adds firmware for the BCM43362 for which recently
> support has been added to the brcmfmac driver.
>=20
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
>  WHENCE                      |    1 +
>  brcm/brcmfmac43362-sdio.bin |  Bin 0 -> 219557 bytes
>  2 files changed, 1 insertion(+)
>  create mode 100644 brcm/brcmfmac43362-sdio.bin
[...]

Applied, thanks.  Sorry for the delay.

Ben.

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-t9i5vZRKg7wP4robzs+D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUyXpNOe/yOyVhhEJAQpP/Q//f9FoKG2AcJanEi0hfhyHnME+OerigBgs
FkMe6UosokdvGqopB58azVXha7I2pizokgW/L6MgdKp02xrE4q+m/HZWujTrdtCS
zzJM8DDwVpk1sVD2IWVnBl1+Kh2R+fuXBpIM+TQib00hPDmph+fL20mkivGXNahR
61lbQg9oVkpgEre4LQALqGqMhWzjuMsPruiluxFgNuRyfGI8FNUFZ1Y0VwlnPdBU
IvTOFIIZrg/P3WK4uRD23vSSKaZrcZTnjC6Wnt7E9uwpOysRbjW+f+hGiHgkJEg+
cZs94GiogVlwriX1IhtZNKGo6lwpzVL6IZBbEpnTRkyH4rYyoqPQTUeCs0K0O9dD
bGh7g82SSTq+futErO0fgkbbJxT+7DVitFElGXDh+0rSRjXCd54h6xPZP5c9RdAb
N3i+NphmjX6uPJ7mdHwJaGh/E4ZPBuVNXBhu2JSLZd9y25sZPEISp850pizWWFJW
x3bmmvdaiA9Ji4T+kdcTOl7Lqa7117HdlqK0bwRvvEuonU5X5H3NVSOMy2Ij4Cm6
LU8YDZ0ho6N72wY0gQ3PU0w1nKqbeVzl/nL4nxBYjpDdrZ5upAAjARlLfbQ47Kxb
/wZC/cM1jAZZ5m1Atk6SdXadZSMwvDHsK++AZOI/HEqWrzte94j7Klq9Ov0eVmZI
az0JMmpwHuw=
=x7TE
-----END PGP SIGNATURE-----

--=-t9i5vZRKg7wP4robzs+D--
