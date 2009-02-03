Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:48688 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbZBCQYs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 11:24:48 -0500
Received: by yx-out-2324.google.com with SMTP id 8so737021yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 08:24:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <40f31dec0902030817h4afacc52uea4885d835444aac@mail.gmail.com>
References: <20090131022310.GA3342@makis>
	 <1233670130.16539.5.camel@maxim-laptop>
	 <40f31dec0902030817h4afacc52uea4885d835444aac@mail.gmail.com>
Date: Tue, 3 Feb 2009 18:24:47 +0200
Message-ID: <40f31dec0902030824s65b90222j13ac9b691593f19f@mail.gmail.com> (sfid-20090203_172451_673682_9DFFFE83)
Subject: Re: [ath5k-devel] [PATCH 1/5] ath5k: PHY code cleanup
From: Nick Kossifidis <mickflemm@gmail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/2/3 Nick Kossifidis <mickflemm@gmail.com>:
> 2009/2/3 Maxim Levitsky <maximlevitsky@gmail.com>:
>> I just tried your 5 patches, as they could fix hangs in the device,
>> that I experience occasionally, when resuming my aspire one from ram.
>>
>> I applied the patches, and I got very unstable system, that tended to
>> hang even before X.
>>
>> When it didn't hang, I tried suspend to ram cycle, but it hanged then.
>>
>>
>> Best regards,
>>        Maxim Levitsky
>>
>>
>
> It's related to unhandled BMISS interrupts, Bob is working on it to
> see what triggers them. A quick solution is to disable them (as we
> don't handle them anyway) but it would be better to know the problem.
>

Hmm if i recall correctly you have a AR2425 right ? I tested this code
on AR2425 before i submit the patches and it worked fine, can you give
me some more infos so i can reproduce this ? What's your setup ?


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
