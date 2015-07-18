Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:36547 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbbGRTH1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jul 2015 15:07:27 -0400
MIME-Version: 1.0
In-Reply-To: <55A90BF4.6040402@gmx.de>
References: <55A43355.2070302@gmx.de>
	<CANUX_P3hndEGmrkUrW2=UjDXU2m=V7o01kabnS_7R-t0nQ0mTA@mail.gmail.com>
	<55A90BF4.6040402@gmx.de>
Date: Sat, 18 Jul 2015 22:07:24 +0300
Message-ID: <CANUX_P1NbGYnkwEqYebcTtL+C4NQF1NS4ji47fsRi9OzcoQk2A@mail.gmail.com> (sfid-20150718_210749_197949_A1660CCF)
Subject: Re: iwlwifi: Microcode SW error detected. Restarting 0x2000000.
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach
egrumbach@gmail.com


On Fri, Jul 17, 2015 at 5:06 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
> On 07/14/2015 08:43 AM, Emmanuel Grumbach wrote:
>> You are not using the latest firmware. Please upgrade to 25.17.12.0.
>
> At least with this firmware the issue is self-healing after a short while - I do not need to restart the interface.
>

Thanks for the feedback.

> FWIW it worked flawlessly since Dec last year so far - no software upgrade at the fritz box nor any hardware change.
> So the current kernel uncovered then an (existing hidden ?) issue, right ?

The current kernel might just be loading a newer firmware that has a regression.
It may very well be a regression in iwlwifi (kernel or firmware).
What you can try is to use an older firmware. kernel 4.0 can still
load -9.ucode and up. So you can just try to downgrade the firmware.
Please use: ethtool -i wlan0 to check the version of the firmware.
Don't rely on the information in modinfo.
