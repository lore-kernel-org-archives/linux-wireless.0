Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38345 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab1FJRTx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 13:19:53 -0400
Received: by qwk3 with SMTP id 3so1427848qwk.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jun 2011 10:19:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DF24685.3080702@broadcom.com>
References: <1307642840-3043-1-git-send-email-arend@broadcom.com>
	<BANLkTim4p+jjm3iT63Lum146K38iGgvhWw@mail.gmail.com>
	<4DF2042C.6060605@broadcom.com>
	<20110610133911.36f9f8b2@Nokia-N900>
	<20110610134016.GC2665@tuxdriver.com>
	<4DF24685.3080702@broadcom.com>
Date: Fri, 10 Jun 2011 19:19:52 +0200
Message-ID: <BANLkTimin2PdRz2CZ2FvJEbW6KLPY63dcA@mail.gmail.com> (sfid-20110610_191956_810363_D87671A8)
Subject: Re: [PATCH] drivers: bcma: export bcma_core_disable() function
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>,
	Michael Buesch <mb@bu3sch.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 10 czerwca 2011 18:29 użytkownik Arend van Spriel
<arend@broadcom.com> napisał:
> On 06/10/2011 03:40 PM, John W. Linville wrote:
>>
>> On Fri, Jun 10, 2011 at 01:39:11PM +0000, Michael Büsch wrote:
>>>
>>> On Fri, 10 Jun 2011 13:46:52 +0200
>>> "Arend van Spriel"<arend@broadcom.com>  wrote:
>>>>>
>>>>> Michael said we should not do do such a exporting without getting
>>>>> users within the same patch serie.
>>>>
>>>> That is going to be hard for me despite my willingness to comply. Our
>>>> driver is still in staging so we submit our brcm80211 patches to Greg
>>>> KH. I figured it would be better to do submit patches for bcma on
>>>> wireless repository.
>>>
>>> There are no rules without exceptions ;-)
>>
>> Right, so I don't really mind taking it.  OTOH, maybe Greg could just
>> carry the patch in his staging tree...?
>>
>> John
>
> Thanks, John
>
> I leave it up to Rafał and Michael to decide. Both ways are fine by me.

Please, take it to wireless tree. I'm going to need this in b43 soon anyway.

-- 
Rafał
