Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64063 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074Ab1CRRY6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 13:24:58 -0400
Received: by vxi39 with SMTP id 39so3744026vxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 10:24:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110318165626.GA12889@sig21.net>
References: <AANLkTik9wfkskAHEpmsm4_gPM0FFBf=q8OVXM99NBRjO@mail.gmail.com>
	<201103172107.25316.helmut.schaa@googlemail.com>
	<AANLkTi=u3dw1D1-+-Cy9aEPc2H1MAF+cUi=ucvMTNrNc@mail.gmail.com>
	<201103181642.28386.helmut.schaa@googlemail.com>
	<AANLkTi=oAQ1M=XmFpyjh+2zkHidN_AdG7880A=TGsM-h@mail.gmail.com>
	<20110318165626.GA12889@sig21.net>
Date: Fri, 18 Mar 2011 18:24:56 +0100
Message-ID: <AANLkTim7QdUByYTDC=ZjjY5ZrAuwhvEUZOKUeGYctXN2@mail.gmail.com>
Subject: Re: [rt2x00-users] rt2800usb stops working with big file transfers in
 AP and IBSS
From: Juan Carlos Garza <juancarlosgarza@gmail.com>
To: Johannes Stezenbach <js@sig21.net>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 18, 2011 at 5:56 PM, Johannes Stezenbach <js@sig21.net> wrote:
> Hi Ivo,
>
> On Fri, Mar 18, 2011 at 05:15:04PM +0100, Ivo Van Doorn wrote:
>> On Fri, Mar 18, 2011 at 4:42 PM, Helmut Schaa
>> <helmut.schaa@googlemail.com> wrote:
>> > Thanks for testing Juan.
>> >
>> > Am Freitag, 18. März 2011 schrieb Juan Carlos Garza:
>> >> I applied the patches (manually), and tested the stick.
>> >>
>> >> The transfer of big loads now is successful.
>> >
>> > Ivo, Johannes, are there any issues left with the async tx status
>> > patches for rt2800usb (in the experimental branch) as they seem to
>> > lower the chance for missed tx status reports.
>>
>> I have to do a performance test to see if there are any issues remaining,
>> but so far all those patches resulted in poorer performance (reduced
>> association successes).
>
> IIRC you did no report any newer test results after
> http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-January/003070.html

I did get once or twice a warning saying:
Queue 14 failed to flush, and I think it did not work afterwards...

I do not need to associate, as I use the Access Point rather than a
Station. Clients could associate with the access point without
problems. But this patch might bring more stability... can someone
give me the path to the experimental branch git repository?

> (I think this change was merged into one of the other patches in rt2x00/experimental)
>
> For me association works fast and reliable with these patches, but I
> did not have time to test with the wpa_supplicant from
> your ros.org code base.
>
> Without the fix above it is clear why association would be unreliable.
>
>
> Johannes
>

Regards
-- 
Juan Carlos
