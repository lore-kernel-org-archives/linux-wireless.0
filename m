Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.243]:39614 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbYGIQZ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 12:25:58 -0400
Received: by hs-out-0708.google.com with SMTP id 4so675386hsl.5
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 09:25:57 -0700 (PDT)
Message-ID: <4874E68F.7090106@gmail.com> (sfid-20080709_182602_610356_C23620B6)
Date: Wed, 09 Jul 2008 19:25:51 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
CC: ipw3945-devel@lists.sourceforge.net,
	=?ISO-8859-1?Q?Stefanik_G=E1bo?= =?ISO-8859-1?Q?r?=
	<netrolller.3d@gmail.com>
Subject: Re: [BUG] Two bugs in monitor mode, iwl3945
References: <485F687C.1050407@gmail.com>
In-Reply-To: <485F687C.1050407@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maxim Levitsky wrote:
> I noticed two bugs:
>=20
> 1) Monitor mode hangs the system randomly, and what is interesting th=
at=20
> this
> bug disappears if I patch the driver with packet injection patch from=
=20
> G=E1bor Stefanik.
> I noticed this bug, after I removed his patch to see if it caused som=
e=20
> problems.
> Always reproducible, usually hangs just after airodump launch.
>=20
> 2) If I enable monitor mode regardless of injection patch, the scanni=
ng=20
> results got garbaged,
> iwlist scan reports > 100 quality on most APs, or 0% quality on my=20
> router, shows extremely low and hi power levels, like
> -127dBm or 160 dBm, and those levels change rapidly.
> This why I removed the injection patch, I suspected it, but this bug=20
> appears to be not related to it.
I noticed that exactly same bug happens if I enable promisc mode on the=
=20
wlan0. Does this give any additional clue why this bug happens?

Best regards,
	Maxim levitsky
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
