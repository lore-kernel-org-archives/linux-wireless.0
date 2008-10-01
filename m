Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:42580 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbYJAXAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2008 19:00:19 -0400
Received: by nf-out-0910.google.com with SMTP id d3so333987nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 01 Oct 2008 16:00:17 -0700 (PDT)
Message-ID: <48E400FA.2090305@gmail.com> (sfid-20081002_010035_516461_45AE554D)
Date: Thu, 02 Oct 2008 00:00:10 +0100
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: TJ <linux@tjworld.net>, Andrey Borzenkov <arvidjaar@mail.ru>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"Casual J. Programmer" <casualprogrammer@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Agere Hermes source-code: copyright situation
References: <200809290949.35749.arvidjaar@mail.ru> <20081001031907.GA19181@kroah.com> <200810011413.17059.arvidjaar@mail.ru> <1222879229.17264.4.camel@hephaestion> <20081001200039.GA29874@kroah.com>
In-Reply-To: <20081001200039.GA29874@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg KH wrote:
> On Wed, Oct 01, 2008 at 05:40:29PM +0100, TJ wrote:
>> On Wed, 2008-10-01 at 14:13 +0400, Andrey Borzenkov wrote:
>>>On Wednesday 01 October 2008, Greg KH wrote:
>>>> On Mon, Sep 29, 2008 at 09:49:34AM +0400, Andrey Borzenkov wrote:
>>>>> I have here driver that can be built for two different types of
>>>>> hardware from basically the same sources (this is port of old Agere
>>>>> drivers for Hermes-I/Hermes-II chipsets).
>>>> 
>>>> Cool, do you have a link to the code, I'd be glad to add it to
>>>> drivers/staging/ if it's not in a fully-mergable state yet to get wider
>>>> users for it.
>>>
>>> You can look at it here: http://arvidjaar.newmail.ru/wlags49.tar.bz
>>>
>>> I doubt that it is suitable for inclusion at current state if ever.
>>> This is taken directly from Agere 2.4 sources; the only parts that were
>>> touched are kernel glue and wireless extensions interface.
>>>
>>> And it is not GPL'ed, of course. I attach E-Mail I received a while
>>> back with answere from Agere legal department.
>>
>> I'm attaching the original email I sent to Agere and their response for
>> the record, hoping it helps clarify the legal position.
> 
> Very nice, thanks for forwarding this on.
> 
> As the license is BSD, that means we can place it in the kernel tree.
> Do you all mind if I add it to the drivers/staging/ directory so you can
> work on cleaning it up within the main kernel tree infrastructure?

(cc'ing linux-wireless)

FYI, Hermes I hardware is already covered by the orinoco driver. WPA and firmware download functionality (which is supported by the Agere driver, but not orinoco in 2.6.27) is already in the wireless queue for 2.6.28.

This leaves Hermes-II (and USB?) hardware which orinoco does not support, but could if someone had access to a card for development.


Regards,

Dave.

