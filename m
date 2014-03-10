Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:47097 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaCJH1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 03:27:47 -0400
MIME-Version: 1.0
In-Reply-To: <CANqatMAgkVqQY3wX_MEj8vjZ2qeOuLFmef8ABtkKmv6j8hO7Dw@mail.gmail.com>
References: <CANqatMD5-vD0m+YAsMqYRPNRKQrKSWthv=Gx+sRRO_Ouw7usZQ@mail.gmail.com>
	<CANUX_P15ryyg3RGqm5pW0oZKTptKHspW=4S76BpMg2GT0nGbUQ@mail.gmail.com>
	<CANqatMAgkVqQY3wX_MEj8vjZ2qeOuLFmef8ABtkKmv6j8hO7Dw@mail.gmail.com>
Date: Mon, 10 Mar 2014 09:27:45 +0200
Message-ID: <CANUX_P2+jN0Wa+G6ZjXGkbsxFgeTCb4AY9vJeJ4qp7y2nh3U7Q@mail.gmail.com> (sfid-20140310_082751_934769_3EF375B7)
Subject: Re: wifi driver or USB might leads suspend/resume failure on thinkpad
 X1 carbon
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Shuduo Sang <sangshuduo@gmail.com>
Cc: linux-usb <linux-usb@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tedd <tedd.an@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 10, 2014 at 8:49 AM, Shuduo Sang <sangshuduo@gmail.com> wrote:
> On Mon, Mar 10, 2014 at 2:11 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>> Hi,
>>
>> On Mon, Mar 10, 2014 at 7:05 AM, Shuduo Sang <sangshuduo@gmail.com> wrote:
>>> Hi,
>>>
>>> Sorry for cross posting. I'm suffering an issue my Thinkpad X1 Carbon
>>> can't resume after suspend recently. I tried many ways including
>>> latest vanilla kernel, latest stable 3.13 and 3.11 kernel but it still
>>> happens. I found it will not happen when I turn off WIFI device or USB
>>> 3.0 in BIOS. So I suspect something need fix in either wifi driver or
>>> USB side. Since Windows 7 works good so I suppose no hardware issue.
>>> Anyone has some ideas to fix it or debug it?
>>>
>>> Thanks,
>>> Shuduo
>>>
>>
>> If you disable WiFi only (without touching USB 3.0 in BIOS), it works?
>> How do you disable WiFi? Rfkill or removing iwlwifi?
>>
>
> I have disabled WIFI device in BIOS, then its suspend/resume works.
>

Do you have any logs to share?
I supposed you tested 3.13.6 right?
