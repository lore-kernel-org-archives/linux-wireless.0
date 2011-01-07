Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36950 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab1AGRtr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 12:49:47 -0500
Message-ID: <4D275236.4040202@candelatech.com>
Date: Fri, 07 Jan 2011 09:49:42 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Chaoxing Lin <CLin@3eti.com>
CC: "'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>
Subject: Re: hostapd hangs on quit, multi-BSSID scenario
References: <BD54DDEB2546894FAB0731EA7B0EDF8D05715D85@RockMX01.rock.corp>
In-Reply-To: <BD54DDEB2546894FAB0731EA7B0EDF8D05715D85@RockMX01.rock.corp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/07/2011 09:44 AM, Chaoxing Lin wrote:
> Gentlemen,
>
>   When I run hostapd with 8+1 BSSID over one radio (ath9160), it runs well. All 9 BSS accepts clients.
> But when I "Ctrl + C" or "killall hostapd", hostapd daemon can NOT gracefully shut down. It hangs forever. I have to "Ctrl + C" again. Then it quits and print message like "
>
> I am running latest (as of 01/06/2011) hostapd, latest stable kernel (2.6.37) with one number change in ath9k to allow more than 12 virtual BSS over one radio.
>
> Below is my hostapd-conf and console screenshot. If someone can fix this bug, please help.

Maybe attach gdb to hostapd and see where it hangs?

Also, what change did you make to ath9k?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
