Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:37224 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab0BHUuK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 15:50:10 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1NeaYY-000660-PR
	for linux-wireless@vger.kernel.org; Mon, 08 Feb 2010 21:50:06 +0100
Received: from ip565776e0.direct-adsl.nl ([86.87.118.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 08 Feb 2010 21:50:06 +0100
Received: from gwingerde by ip565776e0.direct-adsl.nl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 08 Feb 2010 21:50:06 +0100
To: linux-wireless@vger.kernel.org
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 09/10] rt2x00: remove get_tx_stats() mac80211 op
Date: Mon, 08 Feb 2010 21:15:16 +0100
Message-ID: <4B7070D4.4000903@gmail.com>
References: <20100207082044.31474.48583.stgit@tikku>	<20100207082153.31474.76058.stgit@tikku> <4B6EA990.30801@gmail.com> <878wb5ht9f.fsf@purkki.valot.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Gertjan van Wingerde
	<public-gwingerde-Re5JQEeQqe8AvxtiuMwx3w@lo.gmane.org>,
	public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@lo.gmane.org,
	Ivo van Doorn
	<public-IvDoorn-Re5JQEeQqe8AvxtiuMwx3w@lo.gmane.org>
In-Reply-To: <878wb5ht9f.fsf@purkki.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/07/10 18:04, Kalle Valo wrote:
> Gertjan van Wingerde <gwingerde@gmail.com> writes:
> 
>> On 02/07/10 09:21, Kalle Valo wrote:
>>> get_tx_stats() will be removed from mac80211.
>>>
>>> Compile-tested only.
>>>
>>> Cc: Ivo van Doorn <IvDoorn@gmail.com>
>>> Cc: Gertjan van Wingerde <gwingerde@gmail.com>
>>> Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
>>> ---
>>
>> Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
> 
> Thanks.
> 
>> Although I seem to be missing the actual removal of the
>> get_tx_stats from mac80211.
> 
> That's patch 10:
> 
> http://marc.info/?l=linux-wireless&m=126553093501483&w=2
> 

Ah yes, sorry about that. I must have read over it when reading the series.

---
Gertjan.

