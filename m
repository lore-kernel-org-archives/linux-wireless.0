Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from legolas.alcom.aland.fi ([194.112.1.132]:54531 "EHLO
	legolas.alcom.aland.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab1HMNjX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 09:39:23 -0400
Subject: Re: [ath9k-devel] Packet loss regression with Atheros AR9280
From: Jan Sundman <jan.sundman@aland.net>
To: robert@ocallahan.org
Cc: ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Date: Sat, 13 Aug 2011 14:21:12 +0300
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1313234481.2052.7.camel@localhost.localdomain> (sfid-20110813_153929_263888_C244CE95)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm not sure whether you have found a solution to this issue yet but I
thought that I should share my findings. I'm running Arch linux on my
laptop which have the AR9280 and I saw massive packet loss as well.

I noticed however that this _only_ occurred when the laptop was on
battery power. So it seems to be due to some power save functionality
for the card.

"iwconfig wlan0 power off" seems to fix it so I added this to my startup
script and this fixes it. This is of course not a optimal solution but
may point you in the right direction on fixing the problem.

Br,

/Jan

>On 12 August 2011 10:27, Robert O'Callahan ><robert@ocallahan.org>
wrote:

>> Anything I can get building with this kernel, I guess. Any particular
>> version I should try?

>I'd suggest going back a month at a time
>(http://www.orbit-lab.org/kernel/compat-wireless-2.6/2011/), >try each
>until you find one that works, then report >"compat-wireless X works,
>compat-wireless Y doesn't". That'll be a good way to >test multiple
>copies of the development wireless tree.

>If someone Fedora-clued knows which version(s) of the >wireless code
>are involved with Robert's good and bad behaviour >reports, that'll
>also help.

>Anything to kick-start a git bisect :-)

>Ciao,


>Adrian

