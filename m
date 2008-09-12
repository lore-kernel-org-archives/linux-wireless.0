Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34092 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbYILHq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 03:46:58 -0400
Subject: Re: [PATCH] mac80211 hwsim: make radio list dynamic
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1221184233.11498.4.camel@californication>
References: <1221172622.5956.10.camel@johannes.berg>
	 <1221184233.11498.4.camel@californication>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PVt251pewb703owTMj62"
Date: Fri, 12 Sep 2008 09:46:21 +0200
Message-Id: <1221205581.11204.2.camel@johannes.berg> (sfid-20080912_094701_874011_5E4E284C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PVt251pewb703owTMj62
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-12 at 03:50 +0200, Marcel Holtmann wrote:
> Hi Johannes,
>=20
> > This paves the way for dynamic radio additions while the module
> > is loaded. Also restrict the number of radios to 100 because
> > creating that many already takes forever.
>=20
> any plans to do this via configfs in a fully dynamic way. This would
> allow us to emulate hardware hotplug :)

Something like that, yeah. I just didn't want to throw it all into one
patch.

johannes

--=-PVt251pewb703owTMj62
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIyh5IAAoJEKVg1VMiehFYZB8P/j4R/vMPebZ4PYl9sDDLmiZP
/kuG0RwwTDlP/2KAmLKFOfjdAP9+Vb7rt+qKCsDXqCCqF4A6IwUdjmeWodi37iYu
PomoXhv3NngWYa8iIgJQJ4/fB0wA2IYu1qEF58k+MTz+B31BJyfRcEGgtShf30hp
hCE4yFGH9PcREoYc0e1PHp1VtA2tDKqdYVp65B4vTOksrNU0ca4vTmDmMPXLuPsX
eydgSfyLElPGt186+bzdhYB68fT8Sk7TiazJPMBd6fsUkzwQLGwNJMX/cdZhK6df
vn+pqctggQ9oEeQBMyb8fwiXwxWmWf7Xly/zZpt6M8QALESi/negkfQcfPo3u1j5
8mQCeNQj4gug/i/GKA5juPekHJ0MqWuO/G/CSaH7hvLwTtM9ptAeSDjl/2TfGPug
wWVgg2qFgA3K4MCFzJkxYqLFlulCnRSGVWkOXuHCBAYET0KrQ3LIxxvsyex9xBs/
8ouqE4ZCfKLT1yEP001se9u05IJtpfc0w7IKNmFJape6j8ELBbVnu9R4XeI4Gdbf
RPjjx7I3AxFHXlpPMgToctwNs4L8FO30Qm+ue6cQcjkDr7El/5VKmZ0WgRkfv1U2
WgOWIMUnuKDn9R0WfXp6/Adax68lx5WoCuG2NVjXXbFiUBTO5jbiicWzPXsddVbE
/IIgPCKMlXQom1R6AJ2V
=/8s7
-----END PGP SIGNATURE-----

--=-PVt251pewb703owTMj62--

