Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:45045 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab1HSUNK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Aug 2011 16:13:10 -0400
Received: by pzk37 with SMTP id 37so5373575pzk.1
        for <linux-wireless@vger.kernel.org>; Fri, 19 Aug 2011 13:13:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313653897.13224.4.camel@shinybook.infradead.org>
References: <4E3420E9.6080603@lwfinger.net>
	<CACna6ryErHY+OyAnvc9+MYArb5mXpSdadOPADsQOBz796UqSUw@mail.gmail.com>
	<1313617419.3990.134.camel@shinybook.infradead.org>
	<CACna6rzQmEE-EF+7tvQ8vkwp9bYwWMkna3UHw8ym7PmjKWWQTQ@mail.gmail.com>
	<1313653897.13224.4.camel@shinybook.infradead.org>
Date: Fri, 19 Aug 2011 22:13:09 +0200
Message-ID: <CACna6rzsKaHYL4aH9=0X+_6Q7j-_5AnHc7KfiQ9_FxSLhqEPBA@mail.gmail.com> (sfid-20110819_221314_554353_A2FB1D37)
Subject: Re: [PATCH] Add uevent to bcma bus, to autoload drivers.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 18 sierpnia 2011 09:51 użytkownik David Woodhouse
<dwmw2@infradead.org> napisał:
> On Thu, 2011-08-18 at 08:46 +0200, Rafał Miłecki wrote:
>>
>> Tested on my BCM43224, thanks a lot! :)
>>
>> Acked-by: Rafał Miłecki <zajec5@gmail.com>
>>
>> You didn't send this directly to John, not sure if he will pick it up.
>>
>> Do you think this should go for 3.1? With this patch ppl will directly
>> see interface is present and will just use it or see error about
>> firmware in dmesg. Without the patch, person just have to know b43 is
>> supposed to support his card.
>
> Yes, it should go in for 3.1.
>
> I wasn't really expecting John to pick it up. You are the maintainer of
> drivers/bcma, so I'd expect to send it to *you*. Many maintainers would
> be unhappy at patches being sent upstream and bypassing them. Normally
> I'd expect you to pick up the patch and add it to your tree/queue with
> your own signed-off-by, and for it to go upstream that way.

I can accept sending patch directly to John, if I'm included in CC and
linux-wireless is included as well.

However, I can work the way you proposed as well :) Thanks for the
patch, just sent it to John.

-- 
Rafał
