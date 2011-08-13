Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout06.t-online.de ([194.25.134.19]:50613 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab1HMOPJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 10:15:09 -0400
Message-ID: <4E4686C5.4060402@t-online.de> (sfid-20110813_161513_056712_C3D65565)
Date: Sat, 13 Aug 2011 16:14:29 +0200
From: =?UTF-8?B?UmljaGFyZCBTY2jDvHR6?= <r.schtz@t-online.de>
MIME-Version: 1.0
To: Jan Sundman <jan.sundman@aland.net>
CC: robert@ocallahan.org, ath9k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] Packet loss regression with Atheros AR9280
References: <1313234481.2052.7.camel@localhost.localdomain>
In-Reply-To: <1313234481.2052.7.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 13.08.2011 13:21, schrieb Jan Sundman:
> Hi,
>
> I'm not sure whether you have found a solution to this issue yet but I
> thought that I should share my findings. I'm running Arch linux on my
> laptop which have the AR9280 and I saw massive packet loss as well.
>
> I noticed however that this _only_ occurred when the laptop was on
> battery power. So it seems to be due to some power save functionality
> for the card.
>
> "iwconfig wlan0 power off" seems to fix it so I added this to my startup
> script and this fixes it. This is of course not a optimal solution but
> may point you in the right direction on fixing the problem.
>
> Br,
>
> /Jan

It looks like I'm having the same issue with an AR9285. In my 
university's wireless network the packet loss is noticeable higher with 
power management enabled. But at home everything is fine.

-- 
Regards,
Richard Schütz
