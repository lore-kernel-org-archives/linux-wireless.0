Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36516 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZH2JBf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Aug 2009 05:01:35 -0400
Subject: Re: [PATCH 1/2] cfg80211: initialize rate control after station
 inserted
From: Johannes Berg <johannes@sipsolutions.net>
To: tim.gardner@canonical.com
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4A984EBA.9040608@canonical.com>
References: <1251416094-10420-1-git-send-email-reinette.chatre@intel.com>
	 <1251445557.4189.14.camel@johannes.local>
	 <1251474321.3805.73.camel@rc-desk>
	 <1251493298.3456.34.camel@johannes.local>  <4A984EBA.9040608@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EWSgJZ6F0VEhkZ/rFcZZ"
Date: Sat, 29 Aug 2009 11:01:30 +0200
Message-Id: <1251536490.3456.36.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EWSgJZ6F0VEhkZ/rFcZZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-28 at 15:40 -0600, Tim Gardner wrote:

> Wouldn't that make it difficult to experiment with external rate scaling=20
> algorithms? Not that minstrel or the other in-driver rate scaling=20
> algorithms always get it right, but they are certainly more transparent=20
> (and changeable) then firmware.

It does, in theory, but then again you don't really _have_ the choice.
iwlagn only lets you control the rate on the host to some extent,
there's not a lot we can do. IMHO using the rate control algorithms like
they are now is a kludge because we've always needed a rate control
algorithm, but it's still not really useful.

johannes

--=-EWSgJZ6F0VEhkZ/rFcZZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKmO5mAAoJEODzc/N7+QmamPMP+wesiob0ERjIrb9L9XPPPnP2
fDmkT5ujbPeRRAqcpcu5IS140/aVwwYst76no6rVXUikNNwoINlHkhL7izAumA73
qeBmsD92Xg6HBH/vU394S3OmLLLypwroErCjsVgi9xoxrYDgaGIIqitcToi6Zs4c
SiRn+mVzyDB/dfQ3CBmMXb2SWVQ4MxffKqsAJgoxSy32bFRJ469ZHtj3yHMyCrYm
ItANpvWEkDaRFiKPnFtsYnNwKdmJmRE46PcRq3p4WphKCpb/dB8I2paieK09Jukn
0667y7wJbLXxsv9sD3bjF1IZJYoQlJU9tOrVOWKecWYECHL4fVRUmhSsFM640Y6C
XgUjtndojc3JcuVuB+wb35WTTLObxOm58biD8ParJ0V7+bUPRHWJ6JYNLbcU1axj
A0asM7XH5UMb4OFa5N3SJj4IqM16Z9DlqpZQqdMT6T8N4AlTE9FNFPl7b4cnAxOn
cWMUR7yJGOxjuRIaCEl6qTSP1S9wHRBD3KkHn4JWSscoZBMQ0AQaFdZyehH3gyNP
vY94wLoxLgKrtusyv/mi6TJ5FtBoCQFYe8BNjzI38woDY1MVi/PINDRMo4m7hu6U
toyWDCxTPYE0Z2sdqMFzNh3+5ouRgAIqzNMWSZE2Ip26tz3tuYRD/aZ1N6UcHUIt
tqvKgIFiEN9rmluFT1ec
=SWLu
-----END PGP SIGNATURE-----

--=-EWSgJZ6F0VEhkZ/rFcZZ--

