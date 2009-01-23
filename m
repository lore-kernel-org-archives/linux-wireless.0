Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:49982 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975AbZAWTvd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 14:51:33 -0500
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Message-Id: <A10073B8-ED72-4333-B042-D181DE0A0026@ing.unibs.it> (sfid-20090123_205151_735218_F4ED40CC)
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
To: Michael Buesch <mb@bu3sch.de>
In-Reply-To: <200901232037.42512.mb@bu3sch.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: integration of opensource firmware with b43 kernel driver
Date: Fri, 23 Jan 2009 20:51:28 +0100
References: <FF33C500-6653-4A69-B34D-FBE47B2136D3@ing.unibs.it> <497A05DC.4040101@lwfinger.net> <01F0FEC9-8ECF-4284-9428-701B976286D6@ing.unibs.it> <200901232037.42512.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 23, 2009, at 8:37 PM, Michael Buesch wrote:

> On Friday 23 January 2009 20:24:47 Francesco Gringoli wrote:
>> On Jan 23, 2009, at 7:01 PM, Larry Finger wrote:
>>
>>> Francesco Gringoli wrote:
>>>> Hello,
>>>>
>>>> we have been testing the firmware for a week now and it seems
>>>> stable. I
>>>> personally tested it also on a Linksys WRT54GL and it works both in
>>>> station and in AP modes. I collected the feedbacks that some of you
>>>> sent
>>>> and it seems that the firmware now runs on these board:
>>>>
>>>> - 4306, 4311, 4318, 4320
>>>
>>> As a point of clarification, I think this is restricted to the  
>>> 4311/1
>>> as the 4311/2 uses ucode13, not ucode5. If you need a tester for an
>>> open-source version of the 13 firmware, I'm available.
>> Damn... that would be a very hard writing.... We do not have any
>> 4311/2 board: at first glance there are more condition registers  
>> whose
>> meaning we do not know. Very different hardware, didn't know. Thank
>> you for the feedback.
>
> Well, if you didn't notice it already, there are a zillion different  
> flavors
> of the broadcom wireless chip out there. So if you buy a random  
> device, you're almost
> guaranteed that you don't have that flavor already. ;)
Ehm... I begin to notice now... we were so engaged in understanding  
the tx state machine that we lost this _huge_  detail(!). They  
(Broadcom) should have plenty of engineers to design so many different  
chipsets.

Cheers,
-FG
