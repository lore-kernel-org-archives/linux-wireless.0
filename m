Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49361 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab3A1OfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 09:35:25 -0500
Received: by mail-lb0-f174.google.com with SMTP id l12so4001813lbo.33
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2013 06:35:24 -0800 (PST)
From: Erwin Van de Velde <erwin.vandevelde@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: ath9k has buggy promiscuous mode
Date: Mon, 28 Jan 2013 15:35:20 +0100
Message-ID: <1628374.rykW5SrKvm@sylvesterjr.pats.ua.ac.be> (sfid-20130128_153529_528882_E7B68D5A)
In-Reply-To: <87txq1crst.fsf@purkki.adurom.net>
References: <2045349.v6KXL7FGSP@sylvesterjr.pats.ua.ac.be> <87txq1crst.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 28 January 2013 16:20:50 Kalle Valo wrote:
> How did you test this exactly? If you just do 'tcpdump -i wlan0' in
> managed mode which is expected. If you use monitor mode (iw wlan0 
set
> type monitor) when you would see all frames in the air.

I am using tcpdump with the interface in promiscuous mode (not monitor). 
Tested with another driver, data frames from the access point to another 
station are captured as is expected in promiscuous mode. Only ath9k fails 
to do this (other drivers: ralink2800 and iwlwifi).

Best regards,
Erwin

