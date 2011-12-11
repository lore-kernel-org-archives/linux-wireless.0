Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:57870 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab1LKKRH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Dec 2011 05:17:07 -0500
Message-ID: <4EE48317.4020909@rolandgruber.de> (sfid-20111211_111718_446907_CFBD7176)
Date: Sun, 11 Dec 2011 11:16:55 +0100
From: Roland Gruber <post@rolandgruber.de>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org, 651622@bugs.debian.org,
	Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Bug#651622: linux-2.6: Sitecom WLA-2000 v1.001 WLAN stick not
 supported
References: <20111210162607.1020.50335.reportbug@roland>		 <1323537258.18450.100.camel@deadeye> <4EE39C40.4030802@rolandgruber.de>	 <1323543622.25752.4.camel@deadeye> <4EE3D447.7030108@rolandgruber.de> <1323554710.25752.18.camel@deadeye> <4EE3DF19.6080106@rolandgruber.de> <4EE3E9A1.8000004@lwfinger.net>
In-Reply-To: <4EE3E9A1.8000004@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Larry,

Am 11.12.2011 00:22, schrieb Larry Finger:
> The driver for the RTL8188SU is r8712u. Try
> 
> modprobe -rv r8712u
> echo 0df6 005d >  /sys/bus/usb/drivers/r8712u/new_id

wow, this works. Thank you very much for your fast help. :)
This mail is sent via the WLAN stick. ;-)


> If that works, I can add that device ID to the driver.

This would be cool.

Thanks again.


- -- 

Best regards

Roland
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7kgxIACgkQq/ywNCsrGZ7w0ACbBgGP/FzWA7zssUbbR2Run3g8
2pQAnicq2kkoiPsJ6alepA1APel+bnDm
=m5Mw
-----END PGP SIGNATURE-----
