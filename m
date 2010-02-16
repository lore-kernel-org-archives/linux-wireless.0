Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 64.mail-out.ovh.net ([91.121.185.65]:49466 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933242Ab0BPUjc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 15:39:32 -0500
Message-ID: <4B7B027D.70701@free.fr>
Date: Tue, 16 Feb 2010 21:39:25 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: jirislaby@gmail.com, mickflemm@gmail.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: Fix TX/RX padding for all frames
References: <1266190577-2423-1-git-send-email-benoit.papillault@free.fr> <b6c5339f1002151215y4c7d2f33yfd32916e0500b55c@mail.gmail.com> <4B79C565.1050701@free.fr> <20100216004717.GA6844@hash.localnet>
In-Reply-To: <20100216004717.GA6844@hash.localnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland a écrit :
> On Mon, Feb 15, 2010 at 11:06:29PM +0100, Benoit PAPILLAULT wrote:
>   
>>> Can you tell what the functional difference is between the old code and new
>>> code?  E.g. a padding that would be incorrectly computed from before?
>>>
>>>   
>>>       
>> Correct. On some frames padding is incorrect. This patch is more for  
>> completeness since incorrect padding is only found by sending every kind  
>> of frames using a monitor interface. Moreover, since monitor interface  
>> are sometimes used to debug other issues, it's better not to have bugs 
>> here.
>>     
>
> I meant, can you give an example of such a frame?
>
>   
I don't have an ath5k based card at hand. I will try to grab one and 
will give an example of said frame. Basically, I followed the same 
strategy for ath9k already.

Regards,
Benoit

