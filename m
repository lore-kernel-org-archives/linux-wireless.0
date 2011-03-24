Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:11421 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab1CXKKp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 06:10:45 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 24 Mar 2011 03:10:21 -0700
Message-ID: <4D8B189F.3080200@atheros.com>
Date: Thu, 24 Mar 2011 15:40:39 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: Sujith <m.sujith@gmail.com>
CC: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] ath9k: cleanup few redundant macros
References: <1300957576-2734-1-git-send-email-mshajakhan@atheros.com>	<19851.4373.967588.536327@gargle.gargle.HOWL>	<4D8B130E.6090307@atheros.com> <19851.5836.555228.325971@gargle.gargle.HOWL>
In-Reply-To: <19851.5836.555228.325971@gargle.gargle.HOWL>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 24 March 2011 03:32 PM, Sujith wrote:
> Mohammed Shafi wrote:
>    
>>> There's a reason for this: 8813262ea79acf9daa0e03901bdfe93db4dc4ca5
>>> If channel handling has been cleaned up since then, this can be removed.
>>>
>>>        
>> Oh Ok thanks, I will resend the patch without that change.
>> but anyway CHANNEL_G is defined as (CHANNEL_2GHZ|CHANNEL_OFDM).
>>      
> Commit 8813262ea79acf9daa0e03901bdfe93db4dc4ca5 doesn't make much sense.
> Your change looks correct.
>    
Ok Sujith, thanks for the review.
> Sujith
> .
>
>    
