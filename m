Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173003pub.verizon.net ([206.46.173.3]:45027 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbYDOVBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 17:01:39 -0400
Received: from [192.168.1.4] ([71.191.33.184]) by vms173003.mailsrvcs.net
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 with ESMTPA id <0JZD00K7JWXJSM01@vms173003.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Tue, 15 Apr 2008 15:58:32 -0500 (CDT)
Date: Tue, 15 Apr 2008 17:01:23 -0400
From: Dad <ccmcphe@verizon.net>
Subject: Re: mac80211 question
In-reply-to: <200804151521.33963.mb@bu3sch.de>
To: Michael Buesch <mb@bu3sch.de>
Cc: Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Message-id: <480517A3.6070001@verizon.net> (sfid-20080415_220144_275887_FD9276C1)
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
References: <48037A8E.5050200@verizon.net>
 <1208188488.31015.34.camel@localhost.localdomain>
 <4804A9F7.1030507@verizon.net> <200804151521.33963.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Michael, I'll give that a try.


> On Tuesday 15 April 2008 15:13:27 Dad wrote:
>   
>> Our tech support people use it - to distinguish which wireless is for 
>> which work group.
>> You see, we have servers with multiple wireless's and depending on the 
>> work group and
>> location, the nickname aids the tech support people to identify what 
>> wireless a person is
>> using. That is the only reason why we use it. Right now I have created 
>> code for those IOCTL's,
>> so if mac80211 doesn't have it, we can just implement it on our servers.
>>     
>
> Why don't you do that wireless-interface to whatever mapping in userspace?
>
>
>   
