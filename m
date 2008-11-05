Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4-g19.free.fr ([212.27.42.30]:52503 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbYKENOj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 08:14:39 -0500
Message-ID: <49119C3D.1060406@free.fr> (sfid-20081105_141445_043523_C66F9F3C)
Date: Wed, 05 Nov 2008 14:14:37 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Kalle Valo <kalle.valo@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k : Display MAC/BB and RF version at startup
References: <490F63B6.8080600@free.fr> <878ws0ar2u.fsf@nokia.com> <20081105030223.GD16413@tesla>
In-Reply-To: <20081105030223.GD16413@tesla>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Luis R. Rodriguez a =E9crit :
>> I recommend adding a separate function returning the string instead =
of
>> this ugly "%s%s%s%s" trick. Much cleaner that way.

I'm going to send an updated patch.

>=20
> Agreed, also please remove 3x3 comment as we don't have support for
> those yet nor do I even have hardware for it. To be clear ath9k suppo=
rts
> 2x2 right now. :)

Hummm... This is what the Atheros web site says and I have 3 antennas
(very nice connector from UBNT btw). Of course, i don't know if it is
supported by the driver, but at least, I think, it's supported by the
hardware.

Reference : http://www.atheros.com/pt/AR9001AP-3NX2.htm

Regards,
Benoit
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJEZw9OR6EySwP7oIRApusAKDnN+sBIl4hAR2YoAxMaTDkSvvn1QCgompH
a6SODwjspKIGFe8JLT7TnHY=3D
=3DuiLr
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
