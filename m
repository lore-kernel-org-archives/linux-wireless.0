Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-01.arnet.com.ar ([200.45.191.24]:53513 "HELO
	smtp-01.arnet.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760149AbYAKQu2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 11:50:28 -0500
Message-ID: <47879CBD.8080403@marquesminen.com.ar> (sfid-20080111_165030_420994_43D52E69)
Date: Fri, 11 Jan 2008 14:43:41 -0200
From: Martin Marques <martin@marquesminen.com.ar>
MIME-Version: 1.0
To: Larry Finger <larry.finger@lwfinger.net>
CC: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH RFT] b43: Add support for new firmware
References: <200801102046.56979.mb@bu3sch.de> <47879BE4.7040108@lwfinger.net>
In-Reply-To: <47879BE4.7040108@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger escribi=F3:
> Michael Buesch wrote:
>> This patch adds support for new firmware.
>> Please test this on old and new firmware.
>=20
> I have tested this patch with old firmware. It seems to work; however=
 my testing is not complete as
> my computer has started hanging with the "Caps Lock" light flashing. =
The crash is not caused by this
> patch as it happened with 2.6.24-rc5, which has run for many days. I =
do have a suggestion for
> changing the patch (see below).

Sorry if it's a change of subject, but what does the flashing caps hang=
=20
mean? It has happend to me a lot when trying to run 3D apps.
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
