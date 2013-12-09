Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:45756 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286Ab3LIUiv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Dec 2013 15:38:51 -0500
Received: by mail-ea0-f178.google.com with SMTP id d10so1863224eaj.9
        for <linux-wireless@vger.kernel.org>; Mon, 09 Dec 2013 12:38:50 -0800 (PST)
Message-ID: <52A62A58.5060708@gmail.com> (sfid-20131209_213856_436389_608AF796)
Date: Mon, 09 Dec 2013 22:38:48 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi-next 2013-12-2
References: <529CF2D6.1080008@gmail.com> <529E129B.6080807@gmail.com> <20131209202724.GB3359@tuxdriver.com>
In-Reply-To: <20131209202724.GB3359@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12/09/2013 10:27 PM, John W. Linville wrote:
> On Tue, Dec 03, 2013 at 07:19:23PM +0200, Emmanuel Grumbach wrote:
>>
>>
>> On 12/02/2013 10:51 PM, Emmanuel Grumbach wrote:
>>> Hi John,
>>>
>>> This is the fixed and enlarged pull request for 3.14. It includes the
>>> patches in my previous pull request that was based on a bad patch.
>>>
>>> I have here a big rework of the rate control by Eyal. This is obviously
>>> the biggest part of this batch.
>>> I also have enhancement of protection flags by Avri and a few bits for
>>> WoWLAN by Eliad and Luca. Johannes cleans up the debugfs plus a few
>>> fixes. I provided a few things for Bluetooth coexistence.
>>> Besides this we have an implementation for low priority scan.
>>>
>>> Note that I had to merge iwlwifi-fixes into -next to solve conflicts
>>> before they hit linux-next.
>>> Please let me know about issues you may face - Thanks!
>>>
>>
>> So - I found out that merging iwlwifi-fixes wasn't a good idea... So I
>> updated my tree and added a trivial compilation fix.
>>
>> New head: 2f579448f3a60c8ede544dd0951b8d2a2e282ba2.
>>
>> I hope that I have done all the possible mistakes now and that next time
>> I will get it right the first time... Sorry for all the mess...
> 
> This has a couple of merge conflicts when pulling it into
> wireless-next.  I don't have the time to work through them today,
> so I'm not pulling.
> 
> If you would like to work through the resolution and advise me on
> how to do it, I'd love to hear about it. :-)
> 
> John
> 

Cool - I rebased my tree before I read your mail.
