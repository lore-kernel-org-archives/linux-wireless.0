Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f177.google.com ([209.85.216.177]:43859 "EHLO
	mail-px0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbZIHScX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 14:32:23 -0400
Received: by pxi7 with SMTP id 7so3521657pxi.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2009 11:32:26 -0700 (PDT)
Message-ID: <4AA6A339.60109@gmail.com>
Date: Tue, 08 Sep 2009 11:32:25 -0700
From: John Daiker <daikerjohn@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	Dave Young <hidave.darkstar@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: b43 dma error
References: <20090908134732.GA1936@darkstar> <200909081638.36897.mb@bu3sch.de> 	<4AA67009.4020400@lwfinger.net> <4AA69961.9010808@gmail.com> 	<4AA69F61.2040300@lwfinger.net> <69e28c910909081124v71e6fa1cy815a2366385051e6@mail.gmail.com> <4AA6A2B3.2010300@lwfinger.net>
In-Reply-To: <4AA6A2B3.2010300@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/08/2009 11:30 AM, Larry Finger wrote:
> Gábor Stefanik wrote:
>> On Tue, Sep 8, 2009 at 8:16 PM, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>>> Your PHY and your radio are the same as mine. In fact, the one thing I
>>> noticed is that you are using i386 architecture, whereas mine is
>>> x86_64. I have not tested with i386.
>>>
>>> Has anyone run the LP PHY modifications with 32-bit architecture?
>>
>> Yes, me. (With the exact same card as John.)
>
> Is it a maximum memory issue? How much for you?
>
> John and Dave: Same question.
>
> Larry

Only 1 gig for me.  Not seeing any memory pressure on the system, 
though.  Sitting at an idle UNR (Ubuntu Netbook Remix) desktop shows 
only 130 mb in use.

JD
