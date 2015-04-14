Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:36192 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbbDNB7I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2015 21:59:08 -0400
Received: by wgsk9 with SMTP id k9so99642654wgs.3
        for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2015 18:59:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D44F64A-CA84-4489-AD49-2B04A493DD19@embarqmail.com>
References: <430726FF-98A3-4661-ACEE-87781CADD490@embarqmail.com>
 <CAGRGNgUh-n8Grq94YgOAXGR8+hfMHGSx_tQVk6uQaHj9T_U-aQ@mail.gmail.com> <4D44F64A-CA84-4489-AD49-2B04A493DD19@embarqmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 14 Apr 2015 11:58:47 +1000
Message-ID: <CAGRGNgVoxnFaov8PrC1-w9_7UHAdq3_2U+G0m0dbNM3nF9zneg@mail.gmail.com> (sfid-20150414_035912_587142_6D86A4B9)
Subject: Re: DRIVER FOR INTEL2200BG
To: "J.H. Schmidt" <sophiedoc@embarqmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Firstly, reply-all and keep the mailing list (linux-wireless) cc'd,
this discussion might be useful for others in the future.

On Mon, Apr 13, 2015 at 7:42 PM, J.H. Schmidt <sophiedoc@embarqmail.com> wrote:
>
> On Apr 12, 2015, at 8:04 PM, Julian Calaby wrote:
>
>> Hi,
>>
>> On Mon, Apr 13, 2015 at 10:39 AM, J.H. Schmidt <sophiedoc@embarqmail.com> wrote:
>>> My IBM(Lenovo) laptop running XP crashed a year ago and I changed to Lupuplus which
>>> runs on RAM.No problems with older Sprint modem and D link router running Wi Fi.Enter
>>> a nearby lightning strike which killed the router.Century link gave us a new modem router
>>> combo which works fine with with 2 computes r running 7 and 2 IMacs.I can't get the
>>> Linux machine to work with the new Century Link combo modem router-Any ideas?
>>
>> I'm not sure I understand your problem.
>>
>> 1. You're running some RAM based Linux distro on your Thinkpad
>> 2. It has an Intel 2200bg card
>> 3. You've gotten a new router
>> 4. Now it doesn't connect
>>
>> If you were connecting to the old router using WiFi, your card is
>> already working.
>>
>> I'm guessing your new router is much newer than the old one. Is it an
>> "n" router? (I.e. supports 802.11n, WiFi speeds above 54Mbit/s) Some
>> of them default to "n" only operation and need a setting turned on to
>> allow "b" or "g" devices to connect.
>>
>> I'd investigate the settings of the router and ensure that
>> compatibility for older ("g") devices is turned on.
>>
>> Thanks,
>>
>> --
>> Julian Calaby
>>
>> Email: julian.calaby@gmail.com
>> Profile: http://www.google.com/profiles/julian.calaby/

> Thanks for the quick reply.You have the basic facts right.I went to the Ram thumb drive
> when I couldn't get the other Linux CDs etc to work.This is an extra computer that I play
> with while watching TV that had been working fine.I'm going on 86 and not as
> electronically agile as i was .Any help you can give to reset the router or should I trash
> this unit so as not to mess up the wifes I Mac etc.Thanks again.

Firstly, go back to a known good Linux install, i.e. whichever one you
were using when it worked with the old router. The other CDs or thumb
drives or whatever might not have the driver enabled.

I know nothing about Century Link modem-routers, so I cannot help you
with that. Consult their documentation, search for info online,
contact their tech support - someone will have had this problem
before. You're looking for some form of compatibility mode. This will
not break other computers using the network.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
