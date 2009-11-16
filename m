Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44214 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbZKPSHE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 13:07:04 -0500
Subject: Re: compat-wireless and minstrel
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Wozniak <awozniak@irobot.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Derek Smithies <derek@indranet.co.nz>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org
In-Reply-To: <4B0192A6.9050808@irobot.com>
References: <4AF0D54D.4090303@irobot.com>
	 <alpine.DEB.2.00.0911111508391.6214@kauri.acheron.indranet.co.nz>
	 <4AFC655A.5020706@irobot.com> <200911122103.27455.chunkeey@googlemail.com>
	 <4AFC8E4F.5090307@irobot.com>  <4AFC8F0D.5020700@irobot.com>
	 <1258097352.3899.75.camel@johannes.local>  <4AFDDF19.8060202@irobot.com>
	 <1258191039.6167.40.camel@johannes.local>  <4B018B26.2070008@irobot.com>
	 <1258392453.32159.28.camel@johannes.local>  <4B0192A6.9050808@irobot.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/0X5TYV6XWhNb2DefC3V"
Date: Mon, 16 Nov 2009 19:07:07 +0100
Message-ID: <1258394827.32159.34.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/0X5TYV6XWhNb2DefC3V
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-16 at 09:57 -0800, Adam Wozniak wrote:
> This assumption seems too stoichastic.  Reading 802.11-2007 section=20
> 11.1.2.2, it doesn't seem that we're guaranteed to always receive=20
> beacons from all stations.  Stations will cancel their pending beacon=20
> transmission if they receive a beacon before their random delay times=20
> out.  In the extreme case where the number of stations is very large, it=20
> seems possible that you may never hear beacons for some stations.

That is indeed possible, shouldn't happen in the scenario you were
outlining (three stations) though. It's more likely that one of them
doesn't implement beaconing correctly.

It would make sense either way though to send probe requests and
reacting to them and probe responses, if you want to implement that.

johannes

--=-/0X5TYV6XWhNb2DefC3V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLAZTCAAoJEODzc/N7+Qma4FAP/2fh1RBrJlMqNziL2M+7iPfV
JxZOP/5cGDrZP03E5F9JlMFXprxvqaZKI7XjFgdAFmrXQAiCy3N0DJrZDJ3LZGhW
ExQBUFzjEdUs4pGI6V2/VszgpZXBmyHcHN4G3g/Qu3hPwrC84Uo6ExRlJvqZ1DOl
VrvKUb9T48RlmJ+YzE/2ZWe9gjX/BlcBaYbmpvKUuw+pRuMsGsTAgfn1KfGp5eD7
ZkCV3JcBBXQ7xx3kbOldMoowDVkoIRSmdQeg9LkEr9oD6x+i3U2tItFYMUfQSgVH
ftcjvn4BP8/7ButH/0YCqFYff3+iw6j0QHdzxGfN0UhS29cW7Jxakf9nvfJTtLIQ
URJktTNTeOn1T2ZynJ293h/8rjONstcYGBrINIdQggqFxUPUPpJhQ73ApuP+K0qT
nIfA2cG07V/WsgUR9LxNSikIc1d87w6XI2P/PdktKQDNsTwrpxHkRzTuWs3mjuma
sDc+MVa78DDRBNoDSapLPROEXoA3cfJwwT8jpHpsJLEWseU/hmH14WlV3MeSFV+j
G+mLpwoCtzA4KsIrReiFfk1kY3HO0b8TPF8iMe+KjDkuVnWEg5VaCW0a8mXRsZ7a
3LJJU/ZVVgnJdVsASgxhQoAzI+kRyhzpHRaZpXDeOKMUACoCq9WmJft1LRyFo2Ib
X7+nNNkgwe14TqZTimkr
=vDYq
-----END PGP SIGNATURE-----

--=-/0X5TYV6XWhNb2DefC3V--

