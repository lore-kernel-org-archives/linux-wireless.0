Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:45009 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755008Ab2CTOge (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 10:36:34 -0400
Message-ID: <4F6895F0.8020109@tieto.com> (sfid-20120320_153640_893599_9D9BF917)
Date: Tue, 20 Mar 2012 15:36:32 +0100
From: =?UTF-8?B?TWljaGHFgiBLYXppb3I=?= <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 00/11] multi-channel support
References: <6c1d5801-97d8-4534-9225-30b493a925b1@FIVLA-EXHUB02.eu.tieto.com> <1332251040.3329.25.camel@jlt3.sipsolutions.net>
In-Reply-To: <1332251040.3329.25.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Hi,
>
> Thanks for the code! I've started to work on this as well, and will take
> a look at your code soon. I'm currently a bit sick though so it might be
> a couple of days.
>
>> Work still needs to be done:
>>   * powersave per-vif
>>   * queue locking per-vif
>>   * offchannel rework (hw_config, work_work)
>>   * and a bit more
>
> Have you my thoughts at
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/86070
> about the queue issue?

Yes, I've read it. I did think about different approaches to handling 
queues but I decided to do the 'least changes' one for now. I have some 
patches for a simple splitting of tx pending stuff to per-vif and queue 
locking function vif variants. I can send them tomorrow once I clean 
them up.

It seems I failed to use msmtp correctly and my emails ended up only at 
your mailbox. I'll resend them to the mailing list alone. I'm sorry 
about that.


-- Pozdrawiam / Best Regards, Michał Kazior.

