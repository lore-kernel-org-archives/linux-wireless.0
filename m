Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:1878 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbYKUUxn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 15:53:43 -0500
Received: by ug-out-1314.google.com with SMTP id 39so225265ugf.37
        for <linux-wireless@vger.kernel.org>; Fri, 21 Nov 2008 12:53:41 -0800 (PST)
Message-ID: <49271FD1.101@gmail.com> (sfid-20081121_215348_093851_B9885AB9)
Date: Fri, 21 Nov 2008 22:53:37 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] [PATCH] ath5k: set mac address in add_interface
References: <20081118044037.GA18983@hash.localnet> <492710E6.7020506@gmail.com> <b6c5339f0811211201i384ee31dyb5b3998fe02136af@mail.gmail.com>
In-Reply-To: <b6c5339f0811211201i384ee31dyb5b3998fe02136af@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
> On Fri, Nov 21, 2008 at 2:49 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
>> Bob Copeland wrote:
>>> Hi Maxim,
>>>
>>> Please try this patch.  I didn't have a problem changing the mac address
>>> after it was set to something else.  I did kick it to re-associate with
>>> the AP, though.
>>>
>> Tested it, this still doesn't work:
>>
>> iwconfig wlan0 down
>> macchanger wlan0
>> iwconfig wlan0 up
> 
> Wait, don't you want to do ifconfig here?  Or was that just a typo?
> 
> I did exactly that (ifconfig down/macchanger/ifconfig up) and it
> worked here.  In particular if you have mac80211 debugging on it should
> show the mac address changing.  In my case, it didn't matter whether
> I'd previously associated or not.  I did have to tell NetworkManager
> to re-associate though.
> 

Yep, I intended to use ifconfig.

First change after module reload works, second doesn't.

I double check that I use right kernel (install it again).

Best regards,
	Maxim Levitsky



