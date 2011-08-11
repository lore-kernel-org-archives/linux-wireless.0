Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail01.spothost.nl ([77.74.49.150]:46817 "EHLO
	webmail01.spothost.nl" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750825Ab1HKOnD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 10:43:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 11 Aug 2011 14:42:59 +0000
From: kc@cobradevil.org
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8192cu sometimes it can authenticate to ap
In-Reply-To: <4E43E910.7090001@lwfinger.net>
References: <b3059ba2eac66b7ef0ec17c8fe81a1e6@cobradevil.org>
 <34676454425401d650be733a43191a53@cobradevil.org>
 <532595cb4d5ef910de54a4736ba76185@cobradevil.org>
 <4E41624E.3010904@lwfinger.net>
 <d3faeaf2e881a324b0ad3102c10e6131@cobradevil.org>
 <4E429C57.1040101@lwfinger.net>
 <30cc9c22bb40fb1e2bd2b9ef4692d167@cobradevil.org>
 <4E43E910.7090001@lwfinger.net>
Message-ID: <5dbd023b5dea7586dc45393c140316ad@cobradevil.org> (sfid-20110811_164308_139341_7F86B395)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Thu, 11 Aug 2011 09:37:04 -0500, Larry Finger wrote:
> On 08/11/2011 09:23 AM, kc@cobradevil.org wrote:
>> I have now tried several compat files til may 28 but none of them 
>> seems to work
>> with maverick at all. Do i need some updated files on the client to 
>> be able to
>> use the new compat tree?
>>
>> I thought that the compat tree would work without changes on kernel 
>> from >
>> 2.6.30 is that right?
>
> I have no idea what maverick is. I suppose it to be some release of
> Ubuntu, but you really need to specify a kernel version, not a 
> release
> name. Many of us do not use any Debian-based systems for very good
> reasons.

Sorry for that. The kernel is 2.6.35 but your answer makes it clear it 
should work with no extra userland tools.
>
> The compat tree will work without changes on any kernel on which it
> will compile, AS LONG AS THE REST OF THE KERNEL DOES NOT BREAK THE
> WIRELESS.
>
> My full bisection ended up in am impossible result.
>
> The only other thing I can add at the moment, is that rtl8192cu works
> with WEP encryption, thus the part that broke is WPA and WPA2.

Ok but did the driver work before with wpa and or wpa2?
If so do you have an idea which date the compat file should be?

If not then i will have to wait for a fix but i can tell people whats 
wrong.

Larry, thank you very much for your responses.

With kind regards

William van de Velde

>
> Larry

