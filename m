Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:59980 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbXEAKug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2007 06:50:36 -0400
Message-ID: <46371B71.2090508@web.de>
Date: Tue, 01 May 2007 12:50:25 +0200
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Ivo Van Doorn <ivdoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: d80211: How does TX flow control work?
References: <459A5945.80909@web.de>	<20070103185203.2754e059@griffin.suse.cz>	<459BF179.6000906@web.de>	<20070103191853.4f440b8b@griffin.suse.cz>	<459BFB05.9040608@web.de>	<45A03825.9080807@web.de>	<45A2A728.1070404@web.de>	<1175029130.5151.6.camel@johannes.berg>	<460B7CAA.4020604@web.de>	<4637195E.5050907@web.de> <20070501124733.47c45dd0@logostar.upir.cz>
In-Reply-To: <20070501124733.47c45dd0@logostar.upir.cz>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5B38FB125BC7D90FDC17B658"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5B38FB125BC7D90FDC17B658
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Jiri Benc wrote:
> On Tue, 01 May 2007 12:41:34 +0200, Jan Kiszka wrote:
>> Now I came across this issue once again. It is still present, I just
>> observed it over the latest rt2x00 tree after updating shorewall and
>> forgetting to fix its config.
>>
>> I redirected tc to some logging filter, and this is what shorewall doe=
s
>> when "CLEAR_TC=3DYes" is set in shorewall.conf:
>>
>> ...
>> tc qdisc del dev wmaster0 root
>> tc qdisc del dev wmaster0 ingress
>> tc qdisc del dev wlan0 root
>> tc qdisc del dev wlan0 ingress
>=20
> Could you retest with the latest wireless-dev? It should be fixed there=
=2E

Could you point me to the patch(es) in question? I only have 2MBit/s
downlink, so that downloading only the patch would speed things up here.

Jan


--------------enig5B38FB125BC7D90FDC17B658
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGNxtyniDOoMHTA+kRAqlmAJkBe72HiimkDMsnsFxOH7hoZbnxBQCfXCiu
lyKl6WXUNDF1AC3XxfuJdJU=
=gTpV
-----END PGP SIGNATURE-----

--------------enig5B38FB125BC7D90FDC17B658--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
