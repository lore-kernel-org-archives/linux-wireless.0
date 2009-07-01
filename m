Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54713 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbZGASen (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 14:34:43 -0400
Subject: Re: Compiling wpa_supplicant?
From: Johannes Berg <johannes@sipsolutions.net>
To: Jon Loeliger <jdl@bigfootnetworks.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1246467053.11632.13.camel@jdl-desktop>
References: <1246467053.11632.13.camel@jdl-desktop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LfSEdL/zsnm3GEjdVSSV"
Date: Wed, 01 Jul 2009 20:34:31 +0200
Message-Id: <1246473271.8154.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LfSEdL/zsnm3GEjdVSSV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-01 at 11:50 -0500, Jon Loeliger wrote:

> Is there a version of hostapd/wpa_suppliant that is more
> up-to-date WRT libnl-2.0?  Or should I just use the wext
> driver for now?

I would suggest you compile against a released version of libnl, namely
1.1 :) Otherwise, you can rip the compat code out off iw and stick it
into wpa_supplicant/hostapd.

johannes

--=-LfSEdL/zsnm3GEjdVSSV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKS6wyAAoJEODzc/N7+QmaOWUQAMixYPtadcHFXYt/TscBA+OB
Mx5RIyBn+2F7E55gFh/aQ51iww173Lc2dmsKAQmmF8tc48q962uSkTF3ajILfgpY
pH+QmhsXlPviVO5/hlAdwm/w+00wMhN/2vxx6oOV27r7KK37woGsotqCQn1v3aRs
G4kwuNfD619NXvgazZ+VRmceF4F/WtAffPcTCZ9Q+6dtV4JL66sMxY0xASkagso1
DvjAX9Uaox1OMFC0KWsPmkPfTzXsseZwBdMZmxCy+AgiNnW0Zg8SAr3328q+OoWk
q1VBlw8ATxwf3VFm/967+YtAREZ7dqjmub7MnijCKVtEkoE7KpwMyld1atj6FKm4
wL/nWMEqzelqUq/6vV75EN9VC4rn6gyWQ1AUT3cyG01gkpwvWedjwVCtX0CATtYJ
MTP4cfdL9FACenoSKoNzoCuwbT8o+P6LTpvkRwp4LyIV+Sxl6wvZae7j60i16vsI
kznAGFqB4hI2VrD13mAG5Ff7aA8mkjL85mp4Ynp3JsFjIUWqb3zh0ZhuuY8+HaTR
zRBQlDe/TigI99e3BmDR8E6ixQGjWhuRlyG9ptvGYQ9vUXj3oE7dyn/rrprJ3ddL
wfUuv+UoRumRuWfAhGCJHPJz/oYf8pGB5pgcwU0xLYo1hjF79ITC08QYp+Lui/ZU
G24Z++64TnULHBglrC3i
=RWnF
-----END PGP SIGNATURE-----

--=-LfSEdL/zsnm3GEjdVSSV--

