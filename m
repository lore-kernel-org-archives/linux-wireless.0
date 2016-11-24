Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51540 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965318AbcKXLv3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Nov 2016 06:51:29 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Prameela Rani Garnepudi <prameela.garnepudi@redpinesignals.com>
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        hofrat@osadl.org, xypron.glpk@gmx.de
Subject: Re: [1/2] rsi: New firware loading method for RSI 91X devices
References: <1477044595-10348-1-git-send-email-prameela.j04cs@gmail.com>
        <20161109011553.37D03612F2@smtp.codeaurora.org>
        <188f9293-f6a8-bd2b-8c2a-79b620fa0787@redpinesignals.com>
Date: Thu, 24 Nov 2016 13:50:53 +0200
In-Reply-To: <188f9293-f6a8-bd2b-8c2a-79b620fa0787@redpinesignals.com>
        (Prameela Rani Garnepudi's message of "Thu, 24 Nov 2016 11:12:52
        +0530")
Message-ID: <87wpftf65d.fsf@kamboji.qca.qualcomm.com> (sfid-20161124_125134_484396_EDB0747B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prameela Rani Garnepudi <prameela.garnepudi@redpinesignals.com> writes:

>  
> On 11/09/2016 06:45 AM, Kalle Valo wrote: 
>> Prameela Rani Garnepudi <prameela.j04cs@gmail.com> wrote: 
>>> RSI deprecated the old firmware loading method and introduced 
>>> new method using soft boot loader for 9113 chipsets. 
>>> Current driver only supports 9113 device model hence firmware 
>>> loading method has been changed. 
>>> 
>>> In the new method, complete RAM image and flash image are present 
>>> in the flash. Two firmwares present in the device, Boot loader firmware 
>>> and functional firmware. Boot loader firmware is fixed but functional 
>>> firmware can be changed. Before loading the functional firmware, host 
>>> issues commands to check whether existing firmware in the chip and the 
>>> firmware file content to load are same or not. If not, host issues 
>>> commands to load the RAM image and then boot loaded switches to the 
>>> functioanl firmware. 
>>> 
>>> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com> 
>> These two patches are quite big, difficult to review. Smaller changes 
>> would help with that. Will review later. 
>> 
>> 2 patches set to Deferred. 
>> 
>> 9388629 [1/2] rsi: New firware loading method for RSI 91X devices 
>> 9388627 [2/2] rsi: Device initialization sequence is changed 
>> 
> Hi, 
>  
> Can you please let me know when will you consider to review these two  
> patches. Because these are the mandatory and important patches to go  
> into the mail line kernel. If it gets too late can I send each one as  
> patch set? Please let me know urgently. 

I'm still catching up with everything after my travels, sorry for the
delay. I'm hoping to get to your patches in next few days and give
better answers.

>From the last review I noticed that you both moved functions and made
functionality changes in the same patch. These are two logically
different changes and should be in different patches to make the review
easier. That's why I put them to deferred in the first place.

-- 
Kalle Valo
