Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m-04.th.seeweb.it ([217.64.195.227]:52998 "EHLO
	m-04.th.seeweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab0CEUct (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Mar 2010 15:32:49 -0500
Message-ID: <4B916A40.6080607@users.sourceforge.net>
Date: Fri, 05 Mar 2010 21:32:00 +0100
From: "Daniele C." <legolas558@users.sourceforge.net>
MIME-Version: 1.0
To: Luis Correia <luis.f.correia@gmail.com>
CC: Ivo van Doorn <ivdoorn@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: rt2870 (staging kernel driver) crashes fatally
References: <4B8E20CF.50109@users.sourceforge.net>	 <201003051722.42437.IvDoorn@gmail.com>	 <4B9165FE.1080502@users.sourceforge.net>	 <201003052121.44331.IvDoorn@gmail.com> <efe7343f1003051224o4e0774f0v619fe4722e25ab89@mail.gmail.com>
In-Reply-To: <efe7343f1003051224o4e0774f0v619fe4722e25ab89@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

- -------- Original Message  --------
Subject: Re: rt2870 (staging kernel driver) crashes fatally
From: Luis Correia <luis.f.correia@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Date: Fri Mar 05 2010 21:24:06 GMT+0100 (CET)

> Well,
> 
> to set the record straight I did reply privately to tell that staging
> isn't our business.
> 
> But my fault was not to point out the correct mailing list for staging.
> 
> I hope that my apology is accepted.
Of course it is Luis, perhaps I have been a bit irrational in my reply but this is what happened:

* website didn't give a bugtracker URL
* SF.net project was seemingly dead, or more probably I didn't find the new one
* I registered to forums and my registration required manual activation by some admin (a growing climax...)
* I finally wrote to the apparently correct mailing list (I was sure to have read somewhere that it offered support also for the staging driver!), and my message was refused for exceeding size and for not being on topic

At that point, even not being exactly a newbie, I was lost and a bit frustrated. Perhaps you can review the information flow to allow people reach more easily the interesting areas, or perhaps it was just a bad day for me.

Thanks for the correctness of all of you which have replied.

Best regards,
- --
  Daniele

> Luis Correia
> 
> On Fri, Mar 5, 2010 at 20:21, Ivo van Doorn <ivdoorn@gmail.com> wrote:
>> On Friday 05 March 2010, Daniele C. wrote:
>>> -------- Original Message  --------
>>> Subject: Re: rt2870 (staging kernel driver) crashes fatally
>>> From: Ivo van Doorn <ivdoorn@gmail.com>
>>> To: Larry Finger <Larry.Finger@lwfinger.net>
>>> Date: Fri Mar 05 2010 17:22:41 GMT+0100 (CET)
>>>
>>>> On Thursday 04 March 2010, Larry Finger wrote:
>>>>> On 03/03/2010 08:14 PM, Hin-Tak Leung wrote:
>>>>>> You appear to have two issues - (1) the driver doesn't
>>>>>> hibernate/resume well, (2) there is some bad memory leak which causes
>>>>>> your system to run out of memory.
>>>>>>
>>>>>> You did not mention issue (1) - that you were hibernating and resuming
>>>>>> (and expecting it to work, which it does not). For the latter, you
>>>>>> probably need to track down where the memory is leaking in the driver,
>>>>>> which is probably easier than tracking down the hibernate/resume
>>>>>> issue.
>>>>>>
>>>>>> Good luck with tracking down the memory leak. (you do understand that
>>>>>> staging drivers are DIY - i.e. you try it only if you are willing to
>>>>>> look into fixing it yourself - I hope )
>>>>>
>>>>> By generating your own kernel with MEMLEAK enabled, you should be able to see
>>>>> which data blob is being leaked. If you post that info, someone on this list
>>>>> should be able to help you find the cause.
>>>>
>>>> Actually the rt2x00-users list is not intended for the Ralink staging drivers.
>>>> You have to use the staging mailing list: devel@driverdev.osuosl.org
>>>>
>>> Yes, they refused my message but didn't tell anything about the staging mailing list which I couldn't find either and I am now reading from you. Many thanks for pointing this out.
>>
>> Your mail wasn't refused for the rt2x00-users mailinglist, we have a filter that prevents non-subscribed members from sending mails to it.
>> Luis and myself are administrating the list, so your mails were approoved, but we forgot to press the button to allow all your mails
>> to the list to be accepted. :)
>>
>>> I am now running with MEMLEAK enabled, as soon as I will make a new "hammering session" I'll grab the debug data and post another message.
>>
>> Good luck. :)
>>
>> Ivo
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJLkWpAAAoJEON28As9epPAQq4H/RBsF7+r9EvmESHV8N8wlC+c
Sgx/M8fT1vlio7svHTfbP7YQfThOgRl/ox9mrEkdNS8QwpQN0g+D9dH8m1xYkFYO
r1MUXTVGoWHVRP4eyr0+VlFQ1XBM58ig/AojCzAf6bNx8yRIJPRimz2NcoGZT6e5
Utk9HDpBn8cT5Q7cbpM79QGIect7luGYkdhqi62q/IPyLE4MLKSoxSFVYHlbrW08
b2MtqnyWQNc7aNVWfT+ZkCkhmRClWKQSYKaahugnsgYk1fTaFLmKuAKMSqZW9Tmp
X8O9vjx30fT+ms5L/SbgmWNMa9FI4j2obrohIrLWVBjpyTYseWAQnzbue7ybfrs=
=qMs7
-----END PGP SIGNATURE-----
