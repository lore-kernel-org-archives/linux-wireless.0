Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:55942 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757214Ab2CID7K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 22:59:10 -0500
Message-ID: <4F59800B.80407@lwfinger.net> (sfid-20120309_045926_217874_4AF53CAF)
Date: Thu, 08 Mar 2012 21:59:07 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: jerome huang <jerome.syno@gmail.com>
CC: "Xu, Andiry" <Andiry.Xu@amd.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: rt8192cu on USB3
References: <CAHaq0gKf+VE9T15J91rvyxbF8=rNCExTZfE-WcwHjUN1afjnTA@mail.gmail.com> <CAHaq0gLOPpDKazM0WPmkkOmJ1gR-vqOX9Q+J3nXArD5N0MgmMw@mail.gmail.com> <4F581AF8.4080001@lwfinger.net> <CAHaq0gKxw9Lir2bB__jNmmZPzbgq7Ky6v9Ps2RVexbnRjd8a2g@mail.gmail.com> <4F585BA9.6020903@amd.com> <2A76B9D36150BE4293842BC2FE8FF165016A31@SCYBEXDAG04.amd.com> <CAHaq0g+hXKdCaMm8dXiQhzqCsjAa0vihd2YE3gbw-xrMrxmOgw@mail.gmail.com> <CAHaq0gJRr5p2d=P_J9+NQ0=PqaCu6NLSwJ_LSjFn7HffkX-Odg@mail.gmail.com> <4F58F2D0.5060805@lwfinger.net> <CAHaq0gKSSgYX19BH92Pg+gXifSEmjvubc_nd5brO8QeLCpr1yA@mail.gmail.com>
In-Reply-To: <CAHaq0gKSSgYX19BH92Pg+gXifSEmjvubc_nd5brO8QeLCpr1yA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/08/2012 09:28 PM, jerome huang wrote:
>
> It still got no any result if I wait for 30 sec (or longer) between
> (original) step 2 and 3.
> I double confirmed that it always does not work for steps: plugin ->
> up ->  scanning
> and always works for steps: plugin ->  up ->  down ->  up ->  scanning.
>
> And sometimes it works for next down->up->scanning, sometimes it doesn't.
>
> Is the change of firmware loading in kernel 3.3 made by rtlwifi only,
> or ring expansion in xhci is also necessary?

The only changes are in the rtlwifi drivers. I don't have a USB 3 device, thus I 
have no idea what might work there. I wrote something incorrect earlier. The new 
code is not in mainline 3.3, but it is in the wireless-testing git tree. If you 
want to try this, and don't want to get the whole tree, the new code is in the 
bleeding-edge compat-wireless package. Otherwise, I could send you the patches.

Larry


Larry

