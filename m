Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns01.unsolicited.net ([69.10.132.115]:1609 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab0AAOZz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jan 2010 09:25:55 -0500
Message-ID: <4B3E0061.4000003@unsolicited.net>
Date: Fri, 01 Jan 2010 14:02:09 +0000
From: David <david@unsolicited.net>
MIME-Version: 1.0
To: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: linux-kernel@vger.kernel.org,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: 2.6.33-rc1 - Weird hard hangs when rendering 'some' web-sites
 in 	Firefox
References: <4B2FEE46.5030700@unsolicited.net> <8db1092f1001010540l15c8f671y1f6a4a4417eb450b@mail.gmail.com>
In-Reply-To: <8db1092f1001010540l15c8f671y1f6a4a4417eb450b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maciej Rutecki wrote:
> 2009/12/21 David <david@unsolicited.net>:
>   
>> I'm still not sure whether what I'm seeing here is latent hardware
>> problems, but, as a heads up :-
>>
>>    2.6.32, 2.6.32.2 (and previous kernels) - All OK
>>    2.6.33-rc1 - Machine seems fine, until :-
>>
>> I browse to particular sites (one of which is an internet banking site,
>> so no heavy flash etc.). My machine will (completely and repeatably)
>> hang solid. Nothing showing with netconsole, sshd dead, sysrq dead ...
>> reset button time.
>>
>>     
> I can confirm this. Probably it's related only to wireless
> connections, wired seems be OK. My device is:
> 08:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
> [Golan] Network Connection (rev 02)
>
> Regards
>   

Mine is a wired connection, so it seems unconnected with that. I've
replaced the motherboard here and have had no further problems. There is
now a configuration difference though as I've had to disable radeon kms
(with radeon.modeset=0) for the new on-board graphics.

My guess is that this is radeon related, and I'm going to set-up the old
motherboard in a spare case & see what I can work out.

Cheers
David
