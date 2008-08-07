Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47127 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbYHGOrE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 10:47:04 -0400
Subject: Re: [RFC] mac80211/cfg80211: Add BSS configuration options for AP
	mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org,
	Luis Carlos Cobo <luisca@cozybit.com>
In-Reply-To: <20080807142732.GC5138@jm.kir.nu>
References: <20080807134043.GA5138@jm.kir.nu>
	 <1218116906.23048.179.camel@johannes.berg>
	 <20080807141508.GB5138@jm.kir.nu>
	 <1218118732.23048.183.camel@johannes.berg>
	 <20080807142732.GC5138@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XWo73vt+jShVe0V7cNQE"
Date: Thu, 07 Aug 2008 16:46:28 +0200
Message-Id: <1218120388.23048.189.camel@johannes.berg> (sfid-20080807_164708_853961_1C4AEF41)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XWo73vt+jShVe0V7cNQE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-08-07 at 17:27 +0300, Jouni Malinen wrote:

> > Yeah, that was a sticky point... But if you want per-BSS information yo=
u
> > really have to because right now it's per-hw.
>=20
> Well, I don't actually need it per-BSS for hardware that I'm most likely
> to work with ;-), but yeah, this is a per-BSS parameter, so in that
> sense your patch is doing the correct thing.

Yeah, ok, I guess I don't really care, do whichever way you want. It'd
be a bit strange to set it with cfg80211 per BSS and have it show up on
different BSSes, but that's about it, and a little strangeness hasn't
hurt anyone ;)

> > Ok, they can't be per VLAN then, true, but then I think we should limit
> > it to _AP just so nobody tries setting them without effect on other
> > devices or overrides, for _STA, what the AP said. For mesh I don't know
> > (adding Luis) and for IBSS I'm not sure either. I suspect you could use
> > it for IBSS too?
>=20
> I think I'll just make it _AP only for now and if someone ever really
> needs it for something else, they can enable it later.. It is possible
> that new attributes that would be more reasonable for other modes will
> be added in the future for _SET_BSS.

Sure, sounds fine.

johannes

--=-XWo73vt+jShVe0V7cNQE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImwrBAAoJEKVg1VMiehFY03oP/RIKuzCOTGSdtDBN+cjDkiVZ
3YUtNOej8opprMgBs52YBkqCCWQVnYFkZadVcHAmpEpKOWameSxXf+ISLnIZLhx1
QoAbi7ITde/fYh9JRLel0qau06P+GpRaGsb8Jo9UrTvnF8Buz70+qqFozFPN2am8
OlLpy2wFp91hd78B0BVEgOTSn6RFSBqTvNRxmfwj/OCe48wOgVmkKXv/zn32nrOK
5ZNugXySAfuoOr6Gn93NshkPY8Qfp9sDac+ufjRI6Rq8whFrYVk+WGrs0XWdYtTS
KyhNqyjXkBQNXuzxeRL4hinF0w9lmOpcxPf/dnHsskVetS23DsAsV2x3tz3OE+6f
FDq9HMfiM2p0s5y6XbXfyxpkjHPpEcFPdKUW72V4cmmrAXB7DSN0mR7//AGZImfK
hE+gkVRU/8dNXMyFIRm63QvsMje0QfPJgymS4GETN/N3fdF/6HCtogcBwlKlQi62
Itw0IzTPtzVztOI1mBm8lhtJhoSRG/d/0Pa0THqZryiL7wWq8guEGHveFFzc/L0H
EEzknImgM5AhCjpxWZu/TfuEulSYeD/P7gx5q23n4/QIIL4ggMS56fz/+Wp4053p
X/nAY4SqHdjDpe6gOdJ0p5/p+rwcwbQJAi/nw52U3hWlTHNgmfHoxS/4vRVYUoSG
r++F3+RmonlJ0lxr6MkH
=5HBI
-----END PGP SIGNATURE-----

--=-XWo73vt+jShVe0V7cNQE--

