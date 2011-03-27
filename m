Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout09.t-online.de ([194.25.134.84]:56836 "EHLO
	mailout09.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab1C0PIX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Mar 2011 11:08:23 -0400
Message-ID: <4D8F52E2.2010500@t-online.de>
Date: Sun, 27 Mar 2011 17:08:18 +0200
From: =?ISO-8859-1?Q?Richard_Sch=FCtz?= <r.schtz@t-online.de>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Klaus_M=FCller?= <kmueller@justmail.de>
CC: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: Re: broken ath9k-driver - problems with creating new TCP-connections.
 Bad performance
References: <4D8F28C1.4060402@justmail.de> <4D8F2F3E.9030802@openwrt.org> <4D8F4B9F.9010809@justmail.de>
In-Reply-To: <4D8F4B9F.9010809@justmail.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> If the AP is set to HT20, this driver doesn't use IEEE 802.11n any more,
> or, to say it more specific: the selected bit rate is max. 64 Mb/s and
> the performance is even worse.

Of course it uses 802.11n, but only with 20 MHz channel width, so the 
data rate is lower than with 40 Mhz channel width. The highest rate of 
802.11g is 54 Mbit/s anyway.

> I'm wondering at all, why the ath9k driver doesn't switch to 300 Mb/s:
> the rt3572sta-driver doesn't have any problem with both settings.

Your AR9285 only supports up to 150 Mbit/s.

-- 
Regards,
Richard Schütz
