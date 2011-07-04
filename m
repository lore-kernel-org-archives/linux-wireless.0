Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47788 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab1GDU3H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 16:29:07 -0400
Received: by iwn6 with SMTP id 6so4688276iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jul 2011 13:29:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201107042223.33968.chunkeey@googlemail.com>
References: <CAMJnVwmtNBrAbaL5TU-pQO+cvFn=UJC2rQroJeYASL3zJEesaw@mail.gmail.com>
	<201107042202.27366.chunkeey@googlemail.com>
	<CAMJnVwm4Xp87pF7PHLP7vVqF-LYzsgeso7ZPzPwOC_39mwP_Kw@mail.gmail.com>
	<201107042223.33968.chunkeey@googlemail.com>
Date: Mon, 4 Jul 2011 22:29:06 +0200
Message-ID: <CAMJnVwm0WE_T=GztegJaTp_kZttAQnWi_jgbXHk-S6HgP2OyKQ@mail.gmail.com> (sfid-20110704_222912_690402_1FE71620)
Subject: Re: carl9170: Problems setting up Virtual Interface
From: Alex <alex9434@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian,

sorry for bothering you again (thank you very much for your quick answers!!!)

I am quite new to this and don't know how to bring this up to connect
to my router (with WPA2 encryption). ifup does not work:

ifup wlan1-wlan0
Ignoring unknown interface wlan1-wlan0=wlan1-wlan0.

Could you be so kind as to point me in the right direction?

Take care,
Alex

On Mon, Jul 4, 2011 at 10:23 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Monday, July 04, 2011 10:11:59 PM Alex wrote:
>> Great! I now get an additional interface:
>> wlan1-wlan0 Link encap:Ethernet  HWaddr <deleted>
>>           BROADCAST MULTICAST  MTU:1500  Metric:1
>>           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>>           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>>           collisions:0 txqueuelen:1000
>>           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
>>
>> is this the one? Is the name wlan1-wlan0 that I should use to connect?
> seems like it.
>
>> BTW: What is the interface?
>>
>> mon.wlan0 Link encap:UNSPEC  HWaddr <deleted>
>>           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>>           RX packets:3521 errors:0 dropped:0 overruns:0 frame:0
>>           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>>           collisions:0 txqueuelen:1000
>>           RX bytes:585952 (572.2 KiB)  TX bytes:0 (0.0 B)
> It is created by hostapd.
>
> Regards,
>        Chr
>
