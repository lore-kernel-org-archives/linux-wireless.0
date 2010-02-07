Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:42523 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab0BGRCy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 12:02:54 -0500
Received: by wwi18 with SMTP id 18so1368520wwi.19
        for <linux-wireless@vger.kernel.org>; Sun, 07 Feb 2010 09:02:53 -0800 (PST)
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 05/10] b43: remove get_tx_stats() mac80211 op
References: <20100207082044.31474.48583.stgit@tikku>
	<20100207082118.31474.79247.stgit@tikku>
	<201002071232.06381.mb@bu3sch.de>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 07 Feb 2010 19:02:50 +0200
In-Reply-To: <201002071232.06381.mb@bu3sch.de> (Michael Buesch's message of "Sun\, 7 Feb 2010 12\:32\:04 +0100")
Message-ID: <87d40hhtc5.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch <mb@bu3sch.de> writes:

> On Sunday 07 February 2010 09:21:19 Kalle Valo wrote:
>> -		stats[i].count = ring->nr_tx_packets;
>
>> -		stats[i].count = q->nr_tx_packets;
>
> So you can remove the whole nr_tx_packets variable from the data structures,
> because it's only used for the get_stats callback.

Thanks. I'll send v2 of this patch.

-- 
Kalle Valo
