Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38242 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbZEWIYY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 May 2009 04:24:24 -0400
Subject: Re: [PATCH 5/5] libertas: fix WPA adhoc network creation
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1243037398.2495.14.camel@localhost.localdomain>
References: <1243037398.2495.14.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3ClGg2P83ukPWffxPX0J"
Date: Sat, 23 May 2009 10:24:21 +0200
Message-Id: <1243067061.4606.43.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3ClGg2P83ukPWffxPX0J
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-05-22 at 20:09 -0400, Dan Williams wrote:
> Oddly enough, the firmware's JOIN/START commands don't appear to have
> any facility for setting custom IEs, thus the started adhoc network
> doesn't advertise its WPA capability in the beacon.  Whee!

We don't even properly support WPA IBSS in mac80211...

johannes

--=-3ClGg2P83ukPWffxPX0J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKF7KxAAoJEODzc/N7+QmaTsIQALFREjvNWrTF1vQJZ1kU9JGs
zQTsEvqq/F5oz0PP5lWwj4TUmWW1jwQce067go5ROR/I4P0Hdj08wkjFps6p/TT4
wLC3lfN50vQolkWpu8UCWzfw+WxRqVl3P+NdXZynjgGm/OSYf54FJl/Jb+R6y268
EFHfWSSVLlr4ymu5QTHmp7EW/5IqHKDdKVYrGY9OixocqmwKKK8pkIevPKgBb2nh
h4GwU7DJlecIRMm2C37bs8yVHiIlLmgk8hYca9ockq/cJmE75vPaRZDikIs2E56s
UIhlI/SNOdkci2FfavdrlMnBwqLXbloPikhizqHqrGP8wonyraYyY6G6B6zIhTg4
jTgd7TLuo/yM6ha7AnJ1xRfQaMjwNlvFXfmUVdk2mIWltWAS38o03+AWg8MWvhK8
OLPU7oJhX0UolPdHCMf1TDFVePYhH6vg14DxKIl5TDzlMebfkntUCzQH+dE9qSS6
H5bexyK/51lKk600WQxUpNv+u8+wppeuy7b9BEgSuYN6NJfSSMT2UU3v/b2ocSYQ
Ro5QGitThZveLFrChYiaRQ1fHhsRLKrjU1KP21pc1M0pOEHEiWK6oyQT8vxhnyNN
InXd2qMRPnUFrQ00l1xIdo/QD0hI46b+5cpwp3JhmtNsC3hjW+vp3hade1nf7pN5
6z7hGbLCrdEquX7WczQX
=qEF5
-----END PGP SIGNATURE-----

--=-3ClGg2P83ukPWffxPX0J--

