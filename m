Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44880 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab2DXJ0I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 05:26:08 -0400
Received: by vcqp1 with SMTP id p1so331511vcq.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2012 02:26:08 -0700 (PDT)
Message-ID: <4F9671AE.2020105@gmail.com> (sfid-20120424_112612_819031_3C943344)
Date: Tue, 24 Apr 2012 05:26:06 -0400
From: Jonathan Bither <jonbither@gmail.com>
MIME-Version: 1.0
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: New DFS pattern detector
References: <4F965B47.1080000@gmail.com> <4F966960.20700@neratec.com>
In-Reply-To: <4F966960.20700@neratec.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zefir,
	Thanks for the reply. Right now i'm still getting my feet wet as far as kernel driver development, and as such I started to see what I could do to help with the ath5k target as I use that everyday at work. I've been picking little tasks, but as I become more comfortable I wanted to see if I could do more for the community.

Thanks again,
Jonathan Bither

On 04/24/2012 04:50 AM, Zefir Kurtisi wrote:
> Hi Jonathan,
> 
> an earlier proposal for the DFS pattern detector posted at [1] was in fact located in the common ath layer and meant to be used by all DFS capable Atheros devices.
> 
> For the sake of simplicity and based on assumptions that ath9k will be the first driver to use it, the detector was finally moved into ath9k. So far, it is independent of the underlying HW and if there was a consensus that it could be used by ath5k or other drivers, I'll take care to move it back to the ath layer.
> 
> FYI, the initial plans were even to have the detector fully abstracted from the underlying driver and provide it as part of mac80211. With no further feedback from other chip-manufacturers the generic approach was dropped and became Atheros specific.
> 
> 
> Feel free to ask for further details, though I'm out of office right now and will respond delayed.
> 
> HTH, Zefir
> 
> [1] http://article.gmane.org/gmane.linux.kernel.wireless.general/84402
> 
> On 24.04.2012 09:50, Jonathan Bither wrote:
>> Hey List,
>>     With the new DFS pattern detector that was added for ath9k, I was curious if this would be beneficial for the ath5k and possibly other drivers as well. Was there any interest in perhaps making this a common API?
>>
>> Thanks,
>> Jonathan Bither
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
