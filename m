Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:58346 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231AbYKUVpY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 16:45:24 -0500
Received: by ey-out-2122.google.com with SMTP id 6so478299eyi.37
        for <linux-wireless@vger.kernel.org>; Fri, 21 Nov 2008 13:45:22 -0800 (PST)
Message-ID: <49272BEE.2020106@gmail.com> (sfid-20081121_224533_899591_FA69AAED)
Date: Fri, 21 Nov 2008 23:45:18 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] [PATCH] ath5k: set mac address in add_interface
References: <20081118044037.GA18983@hash.localnet> <492710E6.7020506@gmail.com> <b6c5339f0811211201i384ee31dyb5b3998fe02136af@mail.gmail.com> <49271FD1.101@gmail.com>
In-Reply-To: <49271FD1.101@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maxim Levitsky wrote:
> Bob Copeland wrote:
>> On Fri, Nov 21, 2008 at 2:49 PM, Maxim Levitsky 
>> <maximlevitsky@gmail.com> wrote:
>>> Bob Copeland wrote:
>>>> Hi Maxim,
>>>>
>>>> Please try this patch.  I didn't have a problem changing the mac 
>>>> address
>>>> after it was set to something else.  I did kick it to re-associate with
>>>> the AP, though.
>>>>
>>> Tested it, this still doesn't work:
>>>
>>> iwconfig wlan0 down
>>> macchanger wlan0
>>> iwconfig wlan0 up
>>
>> Wait, don't you want to do ifconfig here?  Or was that just a typo?
>>
>> I did exactly that (ifconfig down/macchanger/ifconfig up) and it
>> worked here.  In particular if you have mac80211 debugging on it should
>> show the mac address changing.  In my case, it didn't matter whether
>> I'd previously associated or not.  I did have to tell NetworkManager
>> to re-associate though.
>>
> 
> Yep, I intended to use ifconfig.
> 
> First change after module reload works, second doesn't.
> 
> I double check that I use right kernel (install it again).

compiled kernel again, and installed it, same results.

Best regards,
	Maxim Levitsky

