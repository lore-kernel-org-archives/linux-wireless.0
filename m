Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55164 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbZF2QAp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2009 12:00:45 -0400
Subject: Re: Repeater Bridge Mode with ar9170?
From: Johannes Berg <johannes@sipsolutions.net>
To: Jon Loeliger <jdl@bigfootnetworks.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1246289993.15012.10.camel@jdl-desktop>
References: <1245861185.13356.2.camel@jdl-desktop>
	 <1245881310.13356.10.camel@jdl-desktop>
	 <1246278355.4585.3.camel@johannes.local>
	 <1246289993.15012.10.camel@jdl-desktop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UBPGXzQLPKPfoyBwJp+1"
Date: Mon, 29 Jun 2009 18:00:41 +0200
Message-Id: <1246291242.4585.30.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UBPGXzQLPKPfoyBwJp+1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-29 at 10:39 -0500, Jon Loeliger wrote:

> I think I need to do this strictly from a client/station perspective.
> The only AP in this picture would be the "upstream" AP to which my
> client is associated.  We shouldn't be changing any code running on
> those APs at all.

Right. Still though, an AP implementing it wouldn't seem to be
compliant, so I would have guessed that APs don't implement this.

> Which leads to me trying to figure out how the client is able to
> know what the correct "MAC level NAT address" needs to be to
> when it converts the 802.11 header to the 802.3 header.  Doesn't
> the upstream AP have to have already sent you 4-address frames
> for this to work?  Or will it respond with a 4-address frame if
> it is sent a 4-address frame from the station?

No idea. Nothing of this is specified in 802.11 or anywhere else, so
it's all implementation dependent hacks.

johannes

--=-UBPGXzQLPKPfoyBwJp+1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKSOUmAAoJEODzc/N7+QmaiaQP/2kF7hvEmlkZXSWIfd6GifSI
kHTeJAYinEagxCDb5Yk+WOT2QuvWQtaF4oKhrM5ovTJLPPeAptNAipA9w+WEUMec
zmOlVylqTjZHfXXUiWQKKtgq1GTYNOMpMLTPnsklFcSEjRWuxcsCIWIcEvprt4GN
hDBkXBnpKN3RWXFXJW2yL82++ZyY15Mw0ddG53E7zxqh95cPD1RMm4ij5fJ0+845
1yX4HVs4elzm2PdskuqpqM3GTHzYQuRb8nOZw0X3vpz76PGwmbvuMUHxUs9OU8KK
GfhIs2Zf6a2Q7NTCy+Ui+uukRix/6Yen00aYw2CfZI7YzWIlI9Ed/0pYX4Xk3gJY
rCigLxAx9CFns+I9qCqYtNCZoaKjJzS6jbyC9irfTOI3k+tO1UTXrpV3xtbSNixL
DFfMET6Pe3SbDGxeI340lp+LxLuMPIG7GXNE3zIcoKHIuy5SDFj6faYZDMxEQh7g
ffqtYRJQQQxdOlNQ2gaf2cz1sRe6TaladbJKLCPc+ixWL9v8sLM497DvfPOBMsPr
FnM0CvdmEo3D2HYR37c2J9Fk2VfyGYPEMnLLSBwii7jAV2BeWOoP0NSC4OUpZJwt
YTmZ4toDDxU+2KtsH/yYnKl/70qlt2CUUWlfMqAB5N2aRILGfM2/cpy66XiCQZ+f
wkEpT6DoZ5aRS7lCrjRb
=gnFw
-----END PGP SIGNATURE-----

--=-UBPGXzQLPKPfoyBwJp+1--

