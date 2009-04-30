Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:43372 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbZD3J6L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 05:58:11 -0400
Received: by bwz7 with SMTP id 7so1693566bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 30 Apr 2009 02:58:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <efe7343f0904300251q4650d17nb062cc28b011580d@mail.gmail.com>
References: <wfbpqkvlm0.fsf@calligramme.charmers>
	 <wfzldytr8l.fsf@calligramme.charmers>
	 <efe7343f0904300251q4650d17nb062cc28b011580d@mail.gmail.com>
Date: Thu, 30 Apr 2009 10:58:09 +0100
Message-ID: <efe7343f0904300258u7d29ff3cu9ca8ea3b3038ebab@mail.gmail.com> (sfid-20090430_115816_491036_20248F26)
Subject: Re: rt73usb Access point status
From: Luis Correia <luis.f.correia@gmail.com>
To: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jon,

got the specifics.

On Thu, Apr 30, 2009 at 10:51, Luis Correia <luis.f.correia@gmail.com> =
wrote:
> Hi,
>
> On Thu, Apr 30, 2009 at 10:39, Jon Fairbairn <jon.fairbairn@cl.cam.ac=
=2Euk> wrote:
>>
>> Since no one responded to my previous post, I thought maybe
>> the subject line wasn't attractive enough...
>>
>> On the wiki at <http://wireless.kernel.org/en/users/Drivers>
>> in the AP column it says "yes" with a footnote to the effect that
>> it's "in development". =A0Please can someone clarify this for me?
>>
>> Can I reasonably expect to get an AP going with a usb dongle
>> that requires this driver? Building the latest patched
>> version of the driver is fine, but modifying the driver code
>> would be beyond my (present) capabilities.
>
> Yes, you would manage to get it going without major hassles, but as
> always YMMV...
>
> I know that the Portuguese Classmate-PC clone, Magalh=E3es, has a
> rt73usb and the guys have managed to get it going with a 2.6.27 kerne=
l
> + hostapd. I can ask for specifics if you need.

The solution they have found is not optimal, b ut works in their scenar=
io.

You will need to modify hostapd, according to this blog post:
http://eznemegy.blog.hu/2008/12/14/using_rt2x00_wireless_driver_with_ho=
stapd

HTH

>> --
>> J=F3n Fairbairn =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 Jon.Fairbairn@cl.cam.ac.uk

Luis Correia
rt2x00 project admin
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
