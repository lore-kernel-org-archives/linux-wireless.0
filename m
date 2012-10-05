Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33947 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab2JERpD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 13:45:03 -0400
Message-ID: <506F1C99.6060404@candelatech.com> (sfid-20121005_194509_114035_968A9DA0)
Date: Fri, 05 Oct 2012 10:44:57 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Questions on direct-cabling 3x3 MIMO systems (ath9k)
References: <506DDA1D.1090106@candelatech.com> <CAGRGNgVAehhN8CdwYrG8H4kuad=Kt5tPOHSKCSH8xm-OC=z6aw@mail.gmail.com> <506E10B7.4060406@candelatech.com> <CAGRGNgWhx57oB-wf7DE+V_A1h1K0uHWs0F2jJNyFR58eJ_X5Hg@mail.gmail.com> <506E155E.3030405@candelatech.com> <CAGRGNgU9XdCaes__8MRzkAYjTF7h-zxDY02pW-Bd6nbZpXQMpg@mail.gmail.com>
In-Reply-To: <CAGRGNgU9XdCaes__8MRzkAYjTF7h-zxDY02pW-Bd6nbZpXQMpg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/04/2012 04:48 PM, Julian Calaby wrote:
> Hi Ben,
>

>>> Pretty graphs are always useful. It'd be nice to compare other brands
>>> / models of card too, but I'm guessing that's outside the scope of
>>> what you're planning to achieve.
>>>
>>> Are you planning to open-source any of the software / hardware you're
>>> making to do this?
>>
>>
>> I'm going to publish the code for the attenuator (including
>> eagle layout & gerber files for the Arduino shield).  Will market them
>> for sale as completed units too.  Will publish a simple command-line
>> tool to adjust the attenuation, and unit will have knobs to turn
>> so you don't really need a computer to control it anyway.
>
> Nice! I wish I had a good reason to build one =)
>
>> We'll be able to test various APs..but on the client side,
>> I doubt we'll test other than ath9k anytime soon, although
>> I think our software would support other WiFi NICs if you didn't
>> try to do any of the virtual interface stuff.
>
> Makes sense.

Ok, here's a link that has some pics of the attenuator and a graph
showing link speed, throughput rate, and rx-signal quality.  I have
lots more testing of various combinations, but plan to spend more time
on automating it before I do much more manual testing.

I'll not spam the list further with such links, but feel free to check
back on my blog...I plan to post more results there as I get the time.

http://bens-workshop.blogspot.com/2012/10/programmable-attenuator-arduino-shields.html

If anyone else has any similar data, I'd love to see it posted somewhere.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

