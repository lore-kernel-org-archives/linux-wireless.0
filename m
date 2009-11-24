Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57337 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758101AbZKXTrl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 14:47:41 -0500
Subject: Re: [PATCH 2/2] mac80211: minstrel try all rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Wozniak <awozniak@irobot.com>
Cc: Derek Smithies <derek@indranet.co.nz>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <4B0C37AA.3070805@irobot.com>
References: <4AF0D54D.4090303@irobot.com>	 <4AFDDF19.8060202@irobot.com>
	 <1258191039.6167.40.camel@johannes.local>	 <4B018B26.2070008@irobot.com>
	 <1258392453.32159.28.camel@johannes.local>	 <4B0192A6.9050808@irobot.com>
	 <alpine.DEB.2.00.0911170938380.3829@kauri.acheron.indranet.co.nz>
	 <4B01D4A5.7060204@irobot.com>
	 <alpine.DEB.2.00.0911171156210.3829@kauri.acheron.indranet.co.nz>
	 <4B01E298.3030602@irobot.com>
	 <alpine.DEB.2.00.0911171314470.3829@kauri.acheron.indranet.co.nz>
	 <1258443484.1375.8.camel@johannes.local> <4B02DFE3.9040602@irobot.com>
	 <4B0AEEE3.2050808@irobot.com> <1259018866.7094.189.camel@johannes.local>
	 <4B0B2F6E.7050907@irobot.com> <1259025067.7094.208.camel@johannes.local>
	 <4B0C1527.60305@irobot.com> <1259084493.3491.21.camel@johannes.local>
	 <4B0C1E0A.9020003@irobot.com> <1259085518.3491.24.camel@johannes.local>
	 <4B0C2720.3090308@irobot.com> <1259087819.3491.30.camel@johannes.local>
	 <4B0C2938.1050604@irobot.com> <1259089255.3491.31.camel@johannes.local>
	 <4B0C37AA.3070805@irobot.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-VROJ9wxb8EsjUMMkjpB3"
Date: Tue, 24 Nov 2009 20:47:07 +0100
Message-ID: <1259092027.3491.33.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VROJ9wxb8EsjUMMkjpB3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-24 at 11:44 -0800, Adam Wozniak wrote:
> Johannes Berg wrote:
> > On Tue, 2009-11-24 at 10:43 -0800, Adam Wozniak wrote:
> >  =20
> >> As far as I can tell, minstrel_rate_init does not do any allocation. =20
> >> The pid_algo version does not appear to do any allocation either.
> >>    =20
> >
> > There are three more -- iwlwifi (2x) and ath9k
> >  =20
> Ugh.  Why aren't these in with the mac80211 code?  Do they rely on=20
> something hardware specific?

Yeah ... they should go away.

> I could not find any allocations in the rate_init in any of these:

Ok, but can they all deal with calling get_rate and rate_init at the
same time? I think that could happen now, no?

johannes

--=-VROJ9wxb8EsjUMMkjpB3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLDDg4AAoJEODzc/N7+Qma4pYP+wbHVO6BwmxZlLHlWgOmmQux
qG9tqPuo9Ho3enDrudn4We8WvH68klsa8RVlrXe35ifrq+C9EAk+D/grAfKM/SIC
vkkS9MbjX2ctAT6VQ1zqIKeDHV+U+gk6awevWvIls0XjCwhIKnjP2Qa5xVWkArVM
cWn4gDbO0rwBbEIdk3uj7vk10HwiAjQyamynQLvtXLTJBlMkgJPKVfwTK3BNlumf
msPlLYv8iyqhJXpC1mmpVELbZg8qsJW+LZFdQ1E0Poj9+TUSj7AClvZUb7I7DcFj
gyWeGdKwmM3lpmWsaF3ldCzXilLw0R4TrBaHWahqk25ol3MadIdTeeMQnaH4ADRZ
2wMIuopjRqTwb0qG4uw7w3aA00KbbULCV+/3tOwd20ZqLeGJGAGpI/h02XBZ4wTk
R+Swn4rA7/Y4pitcYN+kr2Ppgj0YQDeiaAubPy4GtCyEnY3is8dXlN3u+zNpU8sN
KJGr1i8MVnq+NjwNntOOGsT4X4C+p9w7q/RqW292dzyN3+RUNlD16EIFtHUkogAE
ouCX6yyDP9bhIhSsru2nIMaza4oCD1jPyUa8FTMNnSFXAoW1k3b+ptEC/tPpgECD
ecVPVm1iWUl/Q+WwsVCbS2W//DoVMTC1EOyYRngham32zAIDDGY5GNKkPoeTCyg8
+gXvBHUWSM/r4xoiLH9D
=wSVN
-----END PGP SIGNATURE-----

--=-VROJ9wxb8EsjUMMkjpB3--

