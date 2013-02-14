Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:42124 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933962Ab3BNLHD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 06:07:03 -0500
Message-ID: <511CC40A.6080104@neratec.com> (sfid-20130214_120711_513782_2FB00F10)
Date: Thu, 14 Feb 2013 12:01:30 +0100
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211: fix auth/assoc timeout handling
References: <1360834178-11599-1-git-send-email-johannes@sipsolutions.net>  <511CC175.9080702@neratec.com> <1360839938.8210.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1360839938.8210.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/2013 12:05 PM, Johannes Berg wrote:
> On Thu, 2013-02-14 at 11:50 +0100, Wojciech Dubowik wrote:
>> I am getting some disconnections becasue of failed
>> nullfunc in my ath9k ap+sta test setup. The auth/assoc
>> don't timeout but nullfunc does.
>>
>> I have checked in wireshark and all nullfunc were
>> properly acknowledged.
>> Attached syslog + iw event.
>>
>> Do you have any idea where it comes from or should
>> I start looking at it?
> No idea right now, off the top of my head, sorry.
>
> johannes
>
So I will start digging.
Wojtek
