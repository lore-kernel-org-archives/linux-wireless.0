Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:62471 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZKHNiu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 08:38:50 -0500
Received: by ewy3 with SMTP id 3so2371374ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 05:38:54 -0800 (PST)
To: Jan Kiszka <jan.kiszka@web.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ar9170 in AP mode
References: <4AF6C7CD.7060108@web.de>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 08 Nov 2009 15:38:52 +0200
In-Reply-To: <4AF6C7CD.7060108@web.de> (Jan Kiszka's message of "Sun\, 08 Nov 2009 14\:29\:49 +0100")
Message-ID: <878wehf85v.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jan Kiszka <jan.kiszka@web.de> writes:

> the ar9170 is not advertising its AP feature. However, hacking in the
> bit allows me to run an AP on my D-Link DWA 160A with the sources of
> yesterday's wireless-testing. Works mostly fine so far, just device
> startup (firmware loading?) is sometimes a bit fragile, and rate control
> seems to jump more than needed when the connection gets worse.
>
> There was some telling the multicast transmission would not work, but I
> just tested it and cannot confirm this. Did something change or does a
> specific multicast scenario still fail? Otherwise I would like to see AP
> mode enabled in the ar9170 so that it works without modifying kernel
> sources. Would post a patch then.

Did you test with a client which had power save mode enabled? That's
the tricky part. 

IMHO AP mode should not be enabled until it's confirmed that power
save mode works properly.

-- 
Kalle Valo
