Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms042pub.verizon.net ([206.46.252.42]:57833 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbYDONNj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 09:13:39 -0400
Received: from [192.168.1.4] ([71.191.33.184])
 by vms042.mailsrvcs.net (Sun Java System Messaging Server 6.2-6.01 (built Apr
 3 2006)) with ESMTPA id <0JZD0088GBEFBH30@vms042.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Tue, 15 Apr 2008 08:13:28 -0500 (CDT)
Date: Tue, 15 Apr 2008 09:13:27 -0400
From: Dad <ccmcphe@verizon.net>
Subject: Re: mac80211 question
In-reply-to: <1208188488.31015.34.camel@localhost.localdomain>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Message-id: <4804A9F7.1030507@verizon.net> (sfid-20080415_141343_931124_AE248B45)
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
References: <48037A8E.5050200@verizon.net>
 <1208188488.31015.34.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Our tech support people use it - to distinguish which wireless is for 
which work group.
You see, we have servers with multiple wireless's and depending on the 
work group and
location, the nickname aids the tech support people to identify what 
wireless a person is
using. That is the only reason why we use it. Right now I have created 
code for those IOCTL's,
so if mac80211 doesn't have it, we can just implement it on our servers.

-Tex


> On Mon, 2008-04-14 at 11:38 -0400, Dad wrote:
>   
>> Are there any plans to include the nickname into mac80211? I noticed 
>> that the version I have the ioctl's for nickname are
>> NULL'ed out.
>>     
>
> Any particular reason you want nickname?  AFAIK it was only used for
> compat with pre-802.11 stuff like WaveLAN and such.  It's pretty much
> useless these days.  Some drivers used it to signal whether they were
> connected or not, but that's a completely bogus use of nickname and not
> something that mac80211 should support.
>
> Dan
>
>
>   
