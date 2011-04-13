Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50134 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757506Ab1DMUZy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 16:25:54 -0400
Message-ID: <4DA606CC.9040609@hauke-m.de>
Date: Wed, 13 Apr 2011 22:25:48 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Walter Goldens <goldenstranger@yahoo.com>
CC: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Compat-wireless release for 2011-04-07 is baked
References: <895357.54625.qm@web161601.mail.bf1.yahoo.com>
In-Reply-To: <895357.54625.qm@web161601.mail.bf1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Walter,

sorry for answering so late.

On 04/08/2011 12:08 AM, Walter Goldens wrote:
> 
>>>
>>> Walter
>> Hi Walter,
>>
>> the subject of this message is wrong, compat-wireless
>> release for
>> 2011-04-07 was not baked, because some patches do not
>> apply. ;-)
>> A successful message should look like this:
>> http://www.spinics.net/lists/linux-wireless/msg66930.html
>> When the statistic is included it was successful.
>>
>> compat-wireless is build automatically by a daily cron job
>> and this cron
>> job also sends these mails.
>>
>> You could apply the patches I send to the mailing list some
>> hours ago
>> and generate your own compat-wireless version or wait some
>> time.
>>
>> Hauke
> 
> Hello Hauke,
> 
> I understand the mechanics of the cron job generating compat-wireless tar balls and emails to the mailing list. I don't understand who /or what/ uploads them in kernel.org and orbit lab?
> http://www.orbit-lab.org/kernel/compat-wireless-2.6/
> http://wireless.kernel.org/download/compat-wireless-2.6/

The cron job generating compat-wireless places it to a location, so it
is available for download on orbit, the cron job is running on a server
at orbit. Now some other cron job copies it to wireless.kernel.org.

The scripts generating compat-wireless can be found here:
http://git.kernel.org/?p=linux/kernel/git/mcgrof/compat-user.git;a=tree

> Walter
> 
> PS, I guess this CW bot "baker" needs a little fine-tuning
Yes that's true. Are you willing to improve it so it generated better
messages on failure?

