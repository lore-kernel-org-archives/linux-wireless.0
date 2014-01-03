Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:51067 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbaACVOH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jan 2014 16:14:07 -0500
Received: by mail-lb0-f177.google.com with SMTP id q8so8265192lbi.22
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jan 2014 13:14:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52C5D96E.7060306@lwfinger.net>
References: <CAC94StQ0EQYDxUQR6jNLEpJjB+tpR9ue2rzesz8uT6cmRTkQ8A@mail.gmail.com>
	<52C5A8DB.2090506@lwfinger.net>
	<CAC94StR7qDESmMiOkrDnFjmOqbmMQNJqMd=zMnMCMZR9tPmi7Q@mail.gmail.com>
	<52C5D96E.7060306@lwfinger.net>
Date: Fri, 3 Jan 2014 21:14:06 +0000
Message-ID: <CAC94StTgBSG927imnZi36b2jXZ4Wt_hQbQ3ceO0co6e_H49n2Q@mail.gmail.com> (sfid-20140103_221411_977794_4B61A5C4)
Subject: Re: RTL8723ae PCI Driver update
From: Chris Taylor <chris.taylor@cantab.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OK, I wasn't aware that it was only a Ubuntu issue. Sorry if it's
sounded like I've criticised your work on the current driver - I
assumed it was an issue affecting all. I've tried the 3.12.6 kernel
but didn't notice any significant difference.

Would you recommend filing a bug report with Ubuntu? If so, do you
have any inkling where the Ubuntu devs should start looking for the
problem?

Thanks,
Chris


On 2 January 2014 21:26, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 01/02/2014 02:44 PM, Chris Taylor wrote:
>>
>> Larry,
>>
>> Thank you for your reply and filling me on the correct netiquette re:
>> driver
>> mailing lists.
>>
>> The PCI ID I have is 10ec:8723, but the built-in version seems to suffer
>> from
>> the slow data rates, poor signal reception and regular dropouts that many
>> users
>> seems to be experiencing with this chipset (at least going by e.g. the
>> Ubuntu
>> forums). I wanted to try compiling my own module from the Realtek source
>> but I
>> think I need a patch to get that to work in kernel 3.11? But I also
>> wondered if
>> it were worth trying a later kernel to see if any of the regular updates
>> have
>> improved things?
>
>
> As I cannot duplicate the results that Ubuntu users seem to have, I don't
> know if there are changes that will help.
>
> It seems to me that there is something in the Ubuntu user code that is
> having problems. I run openSUSE KDE with NetworkManages, and I never have
> any of those difficulties.
>
> Although no changes in rtl8723ae come to mind, there are many changes in the
> mca80211 stack. It is always worthwhile to try a newer kernel, or the
> backports source if you do not want to build a whole new kernel.
>
> Larry
>
>
