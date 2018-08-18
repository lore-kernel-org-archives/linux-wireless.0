Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37858 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbeHRK4w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Aug 2018 06:56:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sat, 18 Aug 2018 00:50:06 -0700
From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/3] Add support for ftm responder configuration
In-Reply-To: <1534407150.3547.58.camel@sipsolutions.net>
References: <1534293018-4930-1-git-send-email-pradeepc@codeaurora.org>
 <1534323867.3547.30.camel@sipsolutions.net>
 <4aaa3a6185dbd116ba5c1a2ce76b691f@codeaurora.org>
 <1534407150.3547.58.camel@sipsolutions.net>
Message-ID: <cd1e8ef5693b81c6b5d25eae36a44fd3@codeaurora.org> (sfid-20180818_095014_905997_2F2749FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> 
> No worries.
> 
>> >
>> > I have no objection to your approach, though I guess it'd be nice if
>> > you
>> > could take a look at the statistics I have exposed and see if those
>> > makes sense or if additional ones are desirable for you, and then we
>> > can combine the work that way, i.e. have your configuration and our stats?
>> 
>> I looked at the patch you posted and this makes sense. I will try to
>> align ath10k driver changes with your approach.
> 
> I tend to actually like your patch better for configuration - no new
> command, though it is, I think, lacking configuration of the necessary
> elements (where do you take the LCI/Civic location from?).
> 
> johannes

Hi Johannes,

I will change the attribute to FLAG type, also add support for LCI/CIVIC 
params
and repost the patch.

Thanks
Pradeep
