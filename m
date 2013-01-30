Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:56230 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414Ab3A3OKb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 09:10:31 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Erwin Van de Velde <erwin.vandevelde@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath9k has buggy promiscuous mode
References: <2045349.v6KXL7FGSP@sylvesterjr.pats.ua.ac.be>
	<87txq1crst.fsf@purkki.adurom.net>
	<1628374.rykW5SrKvm@sylvesterjr.pats.ua.ac.be>
Date: Wed, 30 Jan 2013 16:10:30 +0200
In-Reply-To: <1628374.rykW5SrKvm@sylvesterjr.pats.ua.ac.be> (Erwin Van de
	Velde's message of "Mon, 28 Jan 2013 15:35:20 +0100")
Message-ID: <87a9rqdand.fsf@purkki.adurom.net> (sfid-20130130_151037_143628_DA8D54C2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erwin Van de Velde <erwin.vandevelde@gmail.com> writes:

> On Monday 28 January 2013 16:20:50 Kalle Valo wrote:
>> How did you test this exactly? If you just do 'tcpdump -i wlan0' in
>> managed mode which is expected. If you use monitor mode (iw wlan0 
> set
>> type monitor) when you would see all frames in the air.
>
> I am using tcpdump with the interface in promiscuous mode (not monitor). 
> Tested with another driver, data frames from the access point to another 
> station are captured as is expected in promiscuous mode. Only ath9k fails 
> to do this (other drivers: ralink2800 and iwlwifi).

Heh, I didn't even know we support that. Thanks for educating me :)

-- 
Kalle Valo
