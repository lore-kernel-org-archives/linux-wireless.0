Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:39312 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754607AbYLDOG0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 09:06:26 -0500
Message-ID: <4937E3DF.4030407@lwfinger.net> (sfid-20081204_150630_690068_5D16784D)
Date: Thu, 04 Dec 2008 08:06:23 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Stefanik_G=E1bor?= <netrolller.3d@gmail.com>
CC: Christian Lamparter <chunkeey@web.de>,
	John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	barreyromartin@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] rtl8187: Improve wireless statistics for RTL8187
References: <49375ac0.z1uZDBLv3IxmmMgD%Larry.Finger@lwfinger.net>	 <69e28c910812040444l5d76632ah288078bd3db172d4@mail.gmail.com>	 <200812041357.00103.chunkeey@web.de> <69e28c910812040514l2d325eeekef3decbcce2520b2@mail.gmail.com>
In-Reply-To: <69e28c910812040514l2d325eeekef3decbcce2520b2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefanik G=E1bor wrote:
>=20
>>From an AP ~5M from my antenna, both cards report around -45dBm. I
> haven't tested the p54usb-based algorithm yet.

Both the RTL8187 and the RTL8187B "calibrations" were done using a sing=
le sample
of each device, which is probably risky, but the best I could do.

Is it possible for you to send me the quality and signal strength that =
you
obtain for the RTL8187 at distances of a few cm, 3m and 10m from the AP=
? Please
include which algorithm was used in the conversion.

Thanks,

Larry


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
