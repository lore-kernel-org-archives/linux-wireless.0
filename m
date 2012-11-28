Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:33397 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab2K1MG3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 07:06:29 -0500
Date: Wed, 28 Nov 2012 13:06:18 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	sven@narfation.org, Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH] ath9k: apply coverage class on slottime too
Message-ID: <20121128120618.GA5534@pandem0nium> (sfid-20121128_130632_665505_CE0D4DA9)
References: <1351598855-21427-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <508FCB77.9000303@openwrt.org>
 <508FCF5A.2080204@fokus.fraunhofer.de>
 <508FD505.4080404@openwrt.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
In-Reply-To: <508FD505.4080404@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, Oct 30, 2012 at 02:24:21PM +0100, Felix Fietkau wrote:
> [...]
>
> When I ran the test, the throughput degradation was so big that the
> links became almost useless. It was a long time ago, so maybe this was
> caused by another bug that has been fixed since. I will run another test
> with this patch in a current version...

Felix, did you have the chance to run another test on your link with this
patch? Would be interesting to know if it makes any difference. :)

Thanks,
	Simon

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlC1/joACgkQrzg/fFk7axbneQCgnBIG3OPFRP5KOlfOCHi/pkZv
p8MAn15lRWsZRTanJ/2wO+CLfkvfS7YZ
=YUWi
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
