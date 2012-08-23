Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:43584 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758799Ab2HWP1i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2012 11:27:38 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	openwrt-devel@lists.openwrt.org,
	Marek Lindner <lindner_marek@yahoo.de>,
	Gabor Juhos <juhosg@openwrt.org>,
	Adrian Chadd <adrian.chadd@gmail.com>
Subject: Re: AR9330 hornet board stops beaconing after a few days (0xdeadbeef)
Date: Thu, 23 Aug 2012 17:27:36 +0200
Message-ID: <5082148.VyN1syeFp1@bentobox> (sfid-20120823_172743_602576_286F9A14)
In-Reply-To: <2790102.EX4VJuZDmo@bentobox>
References: <20120813165340.GA10044@pandem0nium> <CAD2nsn2_V-p+8u0VSnkJnjtFF-+nkT=vOLCBqmK9+H=Sj=uhCA@mail.gmail.com> <2790102.EX4VJuZDmo@bentobox>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2381525.Vtg5YvGBVP"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart2381525.Vtg5YvGBVP
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Thursday 23 August 2012 17:19:45 Sven Eckelmann wrote:
> On Thursday 23 August 2012 20:29:47 Mohammed Shafi wrote:
> > >> just to bump again - isn't there anyone who can give us some hint or
> > >> clue regarding these 0xdeadbeef entries in the registers? Couldn't find
> > >> a connection to other reports deadbeef on the mailing list so far.
> > > 
> > > based on the suggestion from Felix Bitterli he says the deadbeef is
> > > due to clocks
> > > of MAC/baseband is off. Adrian says dumping RTC registers might
> > > provide some clue
> > > 
> > > today evening i would just take a look at some h/w specific changes
> > > that were still yet to be in ath9k.
> > 
> > sorry, i am unable to figure out any commits that seems to fix the
> > symptoms
> > like this. i will dig through or ask some one internally.
> > please check with the logs sudo modprobe -v ath9k debug=0x8601
> > with beacon stuck debug enabled
> 
> We have currently the debug running with 0xFFC2D (so also with BS detection
> enabled) since a while. Unfortunately, it takes some days until the problem
> appears and we don't know how to force it to happen immediately.

Ah, sorry. Just noticed that you also wanted to have ATH_DBG_CONFIG enabled. 
Therefore, I changed it to 0xFFE2D right now.

Kind regards,
	Sven
--nextPart2381525.Vtg5YvGBVP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQNkvoAAoJEF2HCgfBJntGEhcQAIy02fmXPmPjq4VMvy1is9d1
bFf10mP2IWCJ0NPSQTNx3CZWjpcuGGftOkiqYm5bYKs2pbptkPx8JlgSvNhXJdAy
D8mxrVUODngDbdBv+oHap/H1bzx3yJ8bqbQvJTEH7+VxqGPvTwDesenZPfd5IP7/
gf9vV3HZ+a6MA12ji0AEGr2KkZjiNRPzTubNqhn+OByfHujveGVnomAf5R2A4emW
JUw8umkXBf4gytw1y7gYKCeMq4dO1vDwJ1Z47pot5w4JDFljtaMv7XGDg6cCHg6f
8PsklZr/Ub6Dtch0ZxuNb2pNhz7zMiqv27Z8tjvskXRc8mAshw7crq8oyZP0hBQq
De88kk+JiqADtXymdSwgbXQYo3Uw2JSm8svsT+Kz7eHC5HdjMFJerMoU1Tf4be7i
TcY9zZyUDhZxMh6kBHCpK0a4VYYENGk5Vo+L4m9GtDeTLehiX8xNpaGg8cGP0zR0
ZRsu3dnebw3YNtDLDKiQ6y9f9D0qzfU1MlvpeLADUwKLPZ01+LY451lyme8z+uK5
HuohgBFOs3SlTKxf0A4S1C4lsabgFELTRRVVD20MqdgBt0VArV+xZvvDpdqdQbKm
uF+ifgM+KW3bn2Mr2WeuvO0W0ZF42PeStnK9PCEBe9HGvHa4HbBaiPbQk7tGRzgo
cp4Q2Eyiz9YZlKy4FjeO
=wtas
-----END PGP SIGNATURE-----

--nextPart2381525.Vtg5YvGBVP--

