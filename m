Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49978 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbYKSUYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 15:24:00 -0500
Subject: Re: Fwd: p54: testing AP mode: cannot switch to master mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefan Steuerwald <salsasepp@googlemail.com>
Cc: linux-wireless@vger.kernel.org, Chr <chunkeey@web.de>
In-Reply-To: <f76a32050811190823r51033a4dqa29de6d1e6663388@mail.gmail.com> (sfid-20081119_172348_017121_7C2EE6B7)
References: <f76a32050811190306s6a86f46dwc245200069ff8a82@mail.gmail.com>
	 <f76a32050811190316o28a49cddte30214c217877078@mail.gmail.com>
	 <1227095773.26243.22.camel@johannes.berg>
	 <f76a32050811190737w37937e17ra361364ed345fd33@mail.gmail.com>
	 <1227109286.26243.54.camel@johannes.berg>
	 <f76a32050811190823r51033a4dqa29de6d1e6663388@mail.gmail.com>
	 (sfid-20081119_172348_017121_7C2EE6B7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WiK71UTX6LMzzPJ7kraj"
Date: Wed, 19 Nov 2008 21:23:24 +0100
Message-Id: <1227126204.26243.62.camel@johannes.berg> (sfid-20081119_212412_952882_F32FF041)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WiK71UTX6LMzzPJ7kraj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-19 at 17:23 +0100, Stefan Steuerwald wrote:

> At first glance this improves things, but not enough. I have an ajax
> application that is polling the web server and which runs into its 5
> sec timeouts fairly regularly. I had this working almost ok before
> with an Atheros card and the latest madwifi driver, but got trashed by
> "stuck beacon" events. I will try this card again with the ath5k
> driver and see how this works.

What's your client? Is it using powersave? Anyone know whether
multicast-after-dtim works correctly in p54? Or maybe there's a bug
hitting with TIM bits? Do you have an extra card that you could use to
monitor and see what happens when it times out?

johannes

--=-WiK71UTX6LMzzPJ7kraj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJHW5AAoJEKVg1VMiehFYQj0QALVSoZS9HFyQz+APsb+sfUb9
JkfSADK75TzrtkcmIzKBg0fl2BpRNE02CURy2CQxFBwaYQ97WhGxc1oGjlBk8cNT
xSqb4Ov0PMpgzC3FYp0eY62aX90ePXisQiGn5r9EITBJSqCgr0zkP2JEGxDlK8kP
GKTqPFNS+9p+TRlbWT3Qad0zh0rHLtT3ZJR9YIUjPENdPJG1UkV+Mmnmp+WzQHSt
L2M3FbZvu+sHIONu0jG3YCJXxy/fVq6VhMTXJp7SywAwqcCY+4IeglGde/G7Y6Qs
c+TBNixrxlDqX+733ZIjBvvgB5aZ/UvnkhsZJllWLZnsJa7o7iXCGkqZa9v2Ez0a
eP5TiwCzBg2cRJLhaZihBZbwq42iiU/eZkLJh9iBEwwcEqIxquj6bvUq8MqUVXrV
ZY76iPCfAk4OoWQhgk6VFwMOiTDzWQ5d7QphHYiZsFJ9tTTC+tEOTW8eXn2IsChL
tDqqfZL6/fP/5gC/zrXrPX6tddqrEnOFNbgWB17mRpJzeB61VmHzJxprRU4A/XMB
WV/dgspkrp4zKXaCTjRe2TdWOMwX0L8XauhzsgXNy7iDYqeKsJOJn3/hfEalvfeW
heYVVF3sifGJ+6IFiRjuAIWrKNkJ+1s4D/hsmgK27uYIKnBYlGlnnnGeHAXQddR1
8khPnwR/C2wHEEd+hPvG
=yuDT
-----END PGP SIGNATURE-----

--=-WiK71UTX6LMzzPJ7kraj--

