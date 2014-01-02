Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:52763 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaABUqJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jan 2014 15:46:09 -0500
Received: by mail-lb0-f172.google.com with SMTP id x18so7693114lbi.3
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jan 2014 12:46:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAC94StR7qDESmMiOkrDnFjmOqbmMQNJqMd=zMnMCMZR9tPmi7Q@mail.gmail.com>
References: <CAC94StQ0EQYDxUQR6jNLEpJjB+tpR9ue2rzesz8uT6cmRTkQ8A@mail.gmail.com>
	<52C5A8DB.2090506@lwfinger.net>
	<CAC94StR7qDESmMiOkrDnFjmOqbmMQNJqMd=zMnMCMZR9tPmi7Q@mail.gmail.com>
Date: Thu, 2 Jan 2014 20:46:07 +0000
Message-ID: <CAC94StSP_tAAw_nsnaZWsmdyyXGVEjDAxV0nAz_e3bBadS_=BQ@mail.gmail.com> (sfid-20140102_214613_387825_53B0A526)
Subject: Fwd: RTL8723ae PCI Driver update
From: Chris Taylor <chris.taylor@cantab.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry,

Thank you for your reply and filling me on the correct netiquette re:
driver mailing lists.

The PCI ID I have is 10ec:8723, but the built-in version seems to
suffer from the slow data rates, poor signal reception and regular
dropouts that many users seems to be experiencing with this chipset
(at least going by e.g. the Ubuntu forums). I wanted to try compiling
my own module from the Realtek source but I think I need a patch to
get that to work in kernel 3.11? But I also wondered if it were worth
trying a later kernel to see if any of the regular updates have
improved things?

Thank you for your help.
Chris


On 2 January 2014 17:58, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
> On 01/02/2014 03:17 AM, Chris Taylor wrote:
>>
>> Hi Larry,
>>
>> Sorry to contact you out of the blue, but I wondered if you could quickly answer
>> a question about Linux drivers for the RTL8723 wireless chipset:
>>
>> Have the native kernel drivers been updated recently, and if so, in which kernel?
>>
>> (I recently downloaded the latest drivers from the Realtek website, but could
>> not get them to compile on a 3.11 kernel.)
>
>
> Chris,
>
> When you contact the listed author of a driver, it is proper netiquette to Cc the appropriate mailing list. In this case linux-wireless@vger.kernel.org would be correct.
>
> That driver was added to the 3.8 kernel, and there have been updates in most kernels since. Does the built-in version not work for you? If your PCI ID is 10ec:b723, that device requires a different driver. I am working on it, but it is not yet ready.
>
> Larry
>
>
