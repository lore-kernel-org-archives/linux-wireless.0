Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41608 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756800Ab1D3NjU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 09:39:20 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Arend van Spriel <arend@broadcom.com>
Cc: Wenceslao =?ISO-8859-1?Q?Gonz=E1lez-Vi=F1as?=
	<wens@fisica.unav.es>, Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"622842@bugs.debian.org" <622842@bugs.debian.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4DBBF2CF.8050608@broadcom.com>
References: <20110415070730.4178.6175.reportbug@calpurnia>
	 <20110415081334.GD1387@vostochny.stro.at>
	 <20110415161039.15535n2vg4igcykg@webmail.unav.es>
	 <20110429164822.62112d9at4vs5xa8@webmail.unav.es>
	 <1304088874.3105.57.camel@localhost>
	 <20110429173944.10906p14p6bdid4w@webmail.unav.es>
	 <1304139874.2833.29.camel@localhost> <4DBBC4DA.8000101@broadcom.com>
	 <20110430103817.14736hcizu57ujrw@webmail.unav.es>
	 <4DBBF2CF.8050608@broadcom.com>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-M07u0grYuP2prHl2N26D"
Date: Sat, 30 Apr 2011 14:39:10 +0100
Message-ID: <1304170750.2833.31.camel@localhost> (sfid-20110430_153924_298651_B1EB3FDC)
Mime-Version: 1.0
Subject: Re: brcm80211 not setting correct country code?
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-M07u0grYuP2prHl2N26D
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2011-04-30 at 13:30 +0200, Arend van Spriel wrote:
> On 04/30/2011 10:38 AM, Wenceslao Gonz=C3=A1lez-Vi=C3=B1as wrote:
> > After
> > iw reg set EU
> > I do not get any answer in dmesg log.
>=20
> I assume you did this as root or used sudo. You may have to check=20
> whether you have the proper udev rules in place. See=20
> http://wireless.kernel.org/en/developers/Regulatory/CRDA#Letting_the_kern=
el_call_CRDA

They are.

> > and if I do (after)  : iw reg get , I get:
> >
> > country 98:
> > 	(2402 - 2472 @ 40), (N/A, 20)
> > 	(5170 - 5250 @ 40), (N/A, 17)
> > 	(5250 - 5330 @ 40), (N/A, 20), DFS
> > 	(5490 - 5600 @ 40), (N/A, 20), DFS
> > 	(5650 - 5710 @ 40), (N/A, 20), DFS
> >
> > So, something is not working properly.
>=20
> I get country US (after iw reg set EU). I tried 'iw reg set ES' after=20
> that and another message showed up in the log:
> [ 1613.052044] cfg80211: Calling CRDA for country: EU
> [ 1845.365115] cfg80211: Pending regulatory request, waiting for it to=
=20
> be processed...
>=20
> It seems cfg80211 expects CRDA to respond to the country setting for EU.=
=20
> I am not familiar what modules are involved in this usage scenario.

I added 'EU' to wireless-regdb in Debian for backward-compatibility.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-M07u0grYuP2prHl2N26D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATbwQ8Oe/yOyVhhEJAQoFmg/9FYQN50dtuWCYxDU9KvpBW3yqkhAQl2KJ
+dgxtQi/sfUbpB/2zJg9/cp6IniVnVf6kGcqz87hdR9VpYcqCpXWnlcUXyg5bVDG
EoW+rJsVYkG2nwkHd7/VvzAbB4ebuDUu23cTcJqtWw8OFXhImv44taFDjJNB0eOh
CJW9lHczFcWJ5aO0fg8/9IzvQY9vbj2WbDfGWSGLEZAu1iJ/JPYA59FQjK3VGNUx
YSMZd8VXI/vlmGi3ks7vlgO7Jd9XUSpmLGTSui04kMrs3IiAaSPPuCl1xoWsJYmX
nyL6kxCtk9odW2gaLd3cK59G6lsI6oxWygW2HEek7OkZT7fY6yWEzczENXRB21cI
e7u7bbFjel05GyaaF8xpL6YUgcp8sKIMZ+eyMwGTQMgOt2q+rVmiw2kYyUUWdXs9
jha9SlOBZvIYNs3ZTfXkuEqiTDHyF2qciX86gp8wn4IOzJv5XTCIwO/tY6SVz5Qi
t+Q6pPImzfrJvW9gvNvKGH9qLyh6/Pg+I7JV/WXtS57Ssuxg7QViFBXxFT20T8Fe
c/H8twmKjr74m4Mw3J75RPO63wOJv8ZDPfhznGWBrlAdHAP+gQyLvkklXAwlJlGH
H4uHZ+x/ukvSnBzIki2WA6xRBrMmwOX+AkaygPNP+n84ZXKsADQwAIAk9MQ3Hvmq
TQn3vboMYpg=
=tFcv
-----END PGP SIGNATURE-----

--=-M07u0grYuP2prHl2N26D--
