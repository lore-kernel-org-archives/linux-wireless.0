Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:40947 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab0BGREc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2010 12:04:32 -0500
Received: by ewy28 with SMTP id 28so1693116ewy.28
        for <linux-wireless@vger.kernel.org>; Sun, 07 Feb 2010 09:04:31 -0800 (PST)
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>
Subject: Re: [PATCH 09/10] rt2x00: remove get_tx_stats() mac80211 op
References: <20100207082044.31474.48583.stgit@tikku>
	<20100207082153.31474.76058.stgit@tikku> <4B6EA990.30801@gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 07 Feb 2010 19:04:28 +0200
In-Reply-To: <4B6EA990.30801@gmail.com> (Gertjan van Wingerde's message of "Sun\, 07 Feb 2010 12\:52\:48 +0100")
Message-ID: <878wb5ht9f.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gertjan van Wingerde <gwingerde@gmail.com> writes:

> On 02/07/10 09:21, Kalle Valo wrote:
>> get_tx_stats() will be removed from mac80211.
>> 
>> Compile-tested only.
>> 
>> Cc: Ivo van Doorn <IvDoorn@gmail.com>
>> Cc: Gertjan van Wingerde <gwingerde@gmail.com>
>> Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
>> ---
>
> Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

Thanks.

> Although I seem to be missing the actual removal of the
> get_tx_stats from mac80211.

That's patch 10:

http://marc.info/?l=linux-wireless&m=126553093501483&w=2

-- 
Kalle Valo
