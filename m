Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:43589 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab2HWP2B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2012 11:28:01 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	openwrt-devel@lists.openwrt.org,
	Marek Lindner <lindner_marek@yahoo.de>,
	Gabor Juhos <juhosg@openwrt.org>,
	Adrian Chadd <adrian.chadd@gmail.com>
Subject: Re: AR9330 hornet board stops beaconing after a few days (0xdeadbeef)
Date: Thu, 23 Aug 2012 17:19:45 +0200
Message-ID: <2790102.EX4VJuZDmo@bentobox> (sfid-20120823_172805_601511_1EBDB80A)
In-Reply-To: <CAD2nsn2_V-p+8u0VSnkJnjtFF-+nkT=vOLCBqmK9+H=Sj=uhCA@mail.gmail.com>
References: <20120813165340.GA10044@pandem0nium> <CAD2nsn0O+dfJLnKroRUJF6TEVWUmgwvriF7M+Oy4YL2ug0gSNA@mail.gmail.com> <CAD2nsn2_V-p+8u0VSnkJnjtFF-+nkT=vOLCBqmK9+H=Sj=uhCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2642597.76mQ79ZJu7"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart2642597.76mQ79ZJu7
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Thursday 23 August 2012 20:29:47 Mohammed Shafi wrote:
> >> just to bump again - isn't there anyone who can give us some hint or
> >> clue regarding these 0xdeadbeef entries in the registers? Couldn't find
> >> a connection to other reports deadbeef on the mailing list so far.
> > 
> > based on the suggestion from Felix Bitterli he says the deadbeef is
> > due to clocks
> > of MAC/baseband is off. Adrian says dumping RTC registers might
> > provide some clue
> > 
> > today evening i would just take a look at some h/w specific changes
> > that were still yet to be in ath9k.
> 
> sorry, i am unable to figure out any commits that seems to fix the symptoms
> like this. i will dig through or ask some one internally.
> please check with the logs sudo modprobe -v ath9k debug=0x8601
> with beacon stuck debug enabled

We have currently the debug running with 0xFFC2D (so also with BS detection 
enabled) since a while. Unfortunately, it takes some days until the problem 
appears and we don't know how to force it to happen immediately.

Kind regards,
	Sven
--nextPart2642597.76mQ79ZJu7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQNkoRAAoJEF2HCgfBJntGadsP/0CZTwP8vEBDDmCnsWrNPQU+
PksLfDLgEnukYvVYUqCDbbrtw+wBAPt20Ir9E+cEAZCxQDHg+X6VBIab40cSd4xT
8BNfwJc8Q9wjiRNkrAd6RTjNG0mKsbibpy/7WfIqk7H/gk3zyLdMoLT6TSCOrMht
T4muqYYz/Jfa2mlXWA4oRVf9Wp36ifwh9EqjD+Jo7tdBVuKkk+iOZZwfWGHla/ON
9s6n0eJeWtdc3ZCXF9kJGXiDbd8dhGpi3I9X80DIsDVRebw+YO57WZRzjEsdZl4a
Z12zbj+c5LiVSlw8Cz8VjbQuutX1GLzVI1nV5zuVkR0A9ATV/cBwY4LYcXsMFrGu
dkcfvxMZ3VzW/NMD6vqHeec25yC/E+dd2vaMtzVuMzzIJ5YyShkqJDP2FaRmWRUf
mUYA+Oxuqe1hETA/fbprTNuygEwwjOL2O826jlOf02+ornDjHwixzfM0ia7OYXv5
BaxCWucGJ33st96xDyPQzeUuh7OpT2Pttz6vsgUT/3zU3++OOrIN4Xg0RsUS6sVY
ryB0NY1VI5dYdaxN0HvMSP2mcrdVtcHXVPrkysai7mSsiM8g9vKUwtH6NCWXi7Iy
ekBqOOeCb9zPLVZZigfKmnSbBaVWvTPGVsRUzXSv95v9lW+poCnaLLtMgoa6ShwM
vIQlJmJNGFnc8pAHhRbX
=K/zI
-----END PGP SIGNATURE-----

--nextPart2642597.76mQ79ZJu7--

