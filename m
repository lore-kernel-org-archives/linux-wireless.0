Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:45754 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbZJPRTX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 13:19:23 -0400
Received: by fxm18 with SMTP id 18so2662044fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2009 10:19:27 -0700 (PDT)
Message-ID: <4AD8AB1C.9070109@gmail.com>
Date: Fri, 16 Oct 2009 13:19:24 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Gabriele Gristina <matrix.use.linux@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fixed injection in monitor mode
References: <1255658961.23827.2.camel@el8pc> <1255704382.4095.340.camel@johannes.local>
In-Reply-To: <1255704382.4095.340.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Fri, 2009-10-16 at 04:09 +0200, Gabriele Gristina wrote:
>   
>> I have a problem with mac80211 injection:
>> if i setup interface in monitor mode with iwconfig and i try to send a
>> custum 802.11 frame i see twice the packet in monitor interface.
>> The first packet is right, the second is different only in the radiotap
>> header: rtap len is fixed to 13 bytes...
>> If i setup interface with airmon-ng the packet is sended once but the
>> radiotap header is fixed to 13 bytes.
>>     
>
> This is correct. The patch is wrong.
>
>   
I'm very stupid, could you please elaborate how seeing every single 
packets twice with different headers is "correct"?

Thanks,
Rick
> johannes
>   

