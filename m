Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60205 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933903AbZKXTBW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 14:01:22 -0500
Subject: Re: [PATCH 2/2] mac80211: minstrel try all rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Wozniak <awozniak@irobot.com>
Cc: Derek Smithies <derek@indranet.co.nz>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <4B0C2938.1050604@irobot.com>
References: <4AF0D54D.4090303@irobot.com>	 <4AFC8F0D.5020700@irobot.com>
	 <1258097352.3899.75.camel@johannes.local>	 <4AFDDF19.8060202@irobot.com>
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
	 <4B0C2938.1050604@irobot.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0NomjhXvyVMSLLrA9XOK"
Date: Tue, 24 Nov 2009 20:00:55 +0100
Message-ID: <1259089255.3491.31.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0NomjhXvyVMSLLrA9XOK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-24 at 10:43 -0800, Adam Wozniak wrote:
> Johannes Berg wrote:
> > However, that reminds me that I actually wanted to get rid of
> > rate_init() since it's mostly not useful to have it separate from
> > alloc_sta()... oh well.
> >
> > I suppose if we document clearly that rate_init maybe called multiple
> > times and audit the existing algorithms the patch could be ok.
> >  =20
> As far as I can tell, minstrel_rate_init does not do any allocation. =20
> The pid_algo version does not appear to do any allocation either.

There are three more -- iwlwifi (2x) and ath9k

johannes

--=-0NomjhXvyVMSLLrA9XOK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLDC1jAAoJEODzc/N7+QmadM4P/0JuTyoPXSuEa9tDLPTwNnmZ
MR5rxJ5V14ySreVJWnT7xdwkLLzPILCXbeH/7Swkdg1mUJrPnhBQPTRTlztlGRPC
RvDMdYqbxFEY4LQwlf25595JA444a2ilWDlIuEiluvxPYVKLSlMVwLcG6atwqQpu
QygYu4gB/w9sXBi2/hJMXYqC7tZlbdAsxB5iFy0NimtG/7P7d/ObFTXIKOGXJziT
adn5Qripz9/+PxLOWSnzwxXyL37N9//qRXsvaMceJbjkpOgbip+SLI9AYQhr3G7K
3FEBqzuaCFSL4XUgBtQrQOaNJ1gTzZdTkU1DK0XexAbpnfbZ37+B71HkkHOHvWnO
bZxUT6mca3jz0dRkLLxeS8byf8e8pDmx1nPplrcz8HNnyBqvczv98d2Kmo9ndmf0
Xih50u3Lu3x+DbxXOet2zKj5T+xd6hXY34zQxLhc8rZFXRLoUfpetJ7GR0d10aUF
t9OX4DxtMqpj5Kv8v4ENYTU3pLzgTH9D4oB4/mJbTMJjsu0C1RUBpmI/rZlhYlBA
5yazMjCKforKKKijZCLBmB4CDjXo6qWsLyGxgrip8IvpqVABT77VgJ71CauEtpSX
YjdMu9JqBkf2AA1Kk75WmD5GVYm8SixOkDUKrvXA9XrORNtOZpwIbq4JK/BdzTwq
5zX5U7C1C4urpVUDFgsz
=nRBk
-----END PGP SIGNATURE-----

--=-0NomjhXvyVMSLLrA9XOK--

