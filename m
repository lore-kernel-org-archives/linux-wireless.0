Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57464 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaABV0J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jan 2014 16:26:09 -0500
Received: by mail-pb0-f46.google.com with SMTP id md12so14993139pbc.33
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jan 2014 13:26:08 -0800 (PST)
Message-ID: <52C5D96E.7060306@lwfinger.net> (sfid-20140102_222613_044099_4DCC8936)
Date: Thu, 02 Jan 2014 15:26:06 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chris Taylor <chris.taylor@cantab.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8723ae PCI Driver update
References: <CAC94StQ0EQYDxUQR6jNLEpJjB+tpR9ue2rzesz8uT6cmRTkQ8A@mail.gmail.com>	<52C5A8DB.2090506@lwfinger.net> <CAC94StR7qDESmMiOkrDnFjmOqbmMQNJqMd=zMnMCMZR9tPmi7Q@mail.gmail.com>
In-Reply-To: <CAC94StR7qDESmMiOkrDnFjmOqbmMQNJqMd=zMnMCMZR9tPmi7Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/02/2014 02:44 PM, Chris Taylor wrote:
> Larry,
>
> Thank you for your reply and filling me on the correct netiquette re: driver
> mailing lists.
>
> The PCI ID I have is 10ec:8723, but the built-in version seems to suffer from
> the slow data rates, poor signal reception and regular dropouts that many users
> seems to be experiencing with this chipset (at least going by e.g. the Ubuntu
> forums). I wanted to try compiling my own module from the Realtek source but I
> think I need a patch to get that to work in kernel 3.11? But I also wondered if
> it were worth trying a later kernel to see if any of the regular updates have
> improved things?

As I cannot duplicate the results that Ubuntu users seem to have, I don't know 
if there are changes that will help.

It seems to me that there is something in the Ubuntu user code that is having 
problems. I run openSUSE KDE with NetworkManages, and I never have any of those 
difficulties.

Although no changes in rtl8723ae come to mind, there are many changes in the 
mca80211 stack. It is always worthwhile to try a newer kernel, or the backports 
source if you do not want to build a whole new kernel.

Larry


