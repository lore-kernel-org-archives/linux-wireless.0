Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:47031 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761482AbZFRMfT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 08:35:19 -0400
Received: by bwz9 with SMTP id 9so1023547bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 05:35:21 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: push rx status into skb->cb
References: <1245237180.20613.4.camel@johannes.local>
	<87d491n3bi.fsf@litku.valot.fi>
	<1245327565.13790.20.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 18 Jun 2009 15:35:19 +0300
In-Reply-To: <1245327565.13790.20.camel@johannes.local> (Johannes Berg's message of "Thu\, 18 Jun 2009 14\:19\:25 +0200")
Message-ID: <873a9x90u0.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> [...]
>> 
>> >  drivers/net/wireless/wl12xx/rx.c           |    3 -
>> 
>> Last night John applied a patch which renamed this to wl1251_rx.c.
>
> He actually applied both patches so I'll assume git resolved this.

Nice. I just love git :)

>> >  drivers/staging/agnx/xmit.c                |    3 -
>> >  drivers/staging/stlc45xx/stlc45xx.c        |    3 -
>> >  drivers/staging/winbond/wb35rx.c           |    3 -
>> 
>> John takes staging patches now? And stlc45xx won't even compile right
>> now :(
>
> Well, I did that with spatch, so ...

Not a problem for me, I was just wondering.

-- 
Kalle Valo
