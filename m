Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:54446 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756733Ab3A1OUw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 09:20:52 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Erwin Van de Velde <erwin.vandevelde@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath9k has buggy promiscuous mode
References: <2045349.v6KXL7FGSP@sylvesterjr.pats.ua.ac.be>
Date: Mon, 28 Jan 2013 16:20:50 +0200
In-Reply-To: <2045349.v6KXL7FGSP@sylvesterjr.pats.ua.ac.be> (Erwin Van de
	Velde's message of "Mon, 28 Jan 2013 10:33:48 +0100")
Message-ID: <87txq1crst.fsf@purkki.adurom.net> (sfid-20130128_152056_301038_8AE9C852)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erwin Van de Velde <erwin.vandevelde@gmail.com> writes:

> When using promiscuous mode on a ath9k chipset, it does not capture 
> packets from the access point to other stations.
>
> e.g. a ping from S to T over AP results in:
> echo request S -> AP
> echo reply AP -> S
>
> Where echo request AP -> T is missing.

How did you test this exactly? If you just do 'tcpdump -i wlan0' in
managed mode which is expected. If you use monitor mode (iw wlan0 set
type monitor) when you would see all frames in the air.

-- 
Kalle Valo
