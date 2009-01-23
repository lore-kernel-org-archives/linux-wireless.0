Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:53173 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbZAWTYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 14:24:52 -0500
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Message-Id: <01F0FEC9-8ECF-4284-9428-701B976286D6@ing.unibs.it> (sfid-20090123_202456_466433_E0170644)
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
To: Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <497A05DC.4040101@lwfinger.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: integration of opensource firmware with b43 kernel driver
Date: Fri, 23 Jan 2009 20:24:47 +0100
References: <FF33C500-6653-4A69-B34D-FBE47B2136D3@ing.unibs.it> <497A05DC.4040101@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 23, 2009, at 7:01 PM, Larry Finger wrote:

> Francesco Gringoli wrote:
>> Hello,
>>
>> we have been testing the firmware for a week now and it seems  
>> stable. I
>> personally tested it also on a Linksys WRT54GL and it works both in
>> station and in AP modes. I collected the feedbacks that some of you  
>> sent
>> and it seems that the firmware now runs on these board:
>>
>> - 4306, 4311, 4318, 4320
>
> As a point of clarification, I think this is restricted to the 4311/1
> as the 4311/2 uses ucode13, not ucode5. If you need a tester for an
> open-source version of the 13 firmware, I'm available.
Damn... that would be a very hard writing.... We do not have any  
4311/2 board: at first glance there are more condition registers whose  
meaning we do not know. Very different hardware, didn't know. Thank  
you for the feedback.

By the way: is that device inside an AP? If yes what? if not which  
brand has the board on? I can look around.

Cheers,
-FG
