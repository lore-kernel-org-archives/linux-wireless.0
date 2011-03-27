Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48374 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab1C0UkN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Mar 2011 16:40:13 -0400
Received: by bwz15 with SMTP id 15so2001818bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Mar 2011 13:40:12 -0700 (PDT)
Message-ID: <4D8F929D.2040701@googlemail.com>
Date: Sun, 27 Mar 2011 21:40:13 +0200
From: Dennis Borgmann <dennis.borgmann@googlemail.com>
MIME-Version: 1.0
To: Sam Leffler <sleffler@google.com>
CC: mickflemm@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: Disabling ACKs with ath5k
References: <4D8C4764.7060107@googlemail.com>	<20110325131957.GA2242@tuxdriver.com>	<4D8C9BC7.3090204@googlemail.com> <BANLkTi=+nCfSj=3w2i-TUr1zawLfvm3Xog@mail.gmail.com>
In-Reply-To: <BANLkTi=+nCfSj=3w2i-TUr1zawLfvm3Xog@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Sam,
hello Nick,

thank you for your hints. Multicasting was an option already before.
With your expert opinion I am now confident, that this idea wasn't that bad.

Anyway, i will have a look at the hints given by Nick.

Thank you for your thoughts. It will help me.

Best regards from Germany,
Dennis

Sam Leffler schrieb:
> On Fri, Mar 25, 2011 at 6:42 AM, Dennis Borgmann <
> dennis.borgmann@googlemail.com> wrote:
>
>   
>> Hello John,
>>
>> the goal would be to have a transmission as fast as possible while
>> ignoring, if a packet reached its destination or not. I'd like to test
>> wireless performance regarding transmission time in a dedicated
>> environment. As far as I can see, backoff might already push the
>> transmission times up quite a lot and if I'd even add the time of -
>> worst case - 10 retransmissions, the transmission time of one packet
>> will grow even more.
>>
>> It would be second-rank, if the packet reaches its destination. Loss of
>> some packets is not a problem in my testbed.
>>
>> So I'd like to disable usage of ACKs in order to be off with the only
>> problem - backoff. Disabling this would of course be nice, but I fear,
>> that's far more work that just disabling ACKs.
>>
>>     
>
> Send multicast frames.
>
> -Sam
>
>   

