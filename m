Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41632 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab2C1S46 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 14:56:58 -0400
Message-ID: <4F735EF5.3010708@candelatech.com> (sfid-20120328_205702_172419_F47B1F95)
Date: Wed, 28 Mar 2012 11:56:53 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Bryan Phillippe <Bryan.Phillippe@watchguard.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: bss_info_change_notify warning (hacked 3.3.0-rc5+)
References: <4F57B7E6.1050103@candelatech.com> <D6CE340A-7CE4-42DA-B1C3-4137C1D13BFF@watchguard.com>
In-Reply-To: <D6CE340A-7CE4-42DA-B1C3-4137C1D13BFF@watchguard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/07/2012 11:45 AM, Bryan Phillippe wrote:
>
> Yes, it's a known problem.  It's very reproducible for me on a non-hacked 3.3-rc1 as well: changing from AP to client mode, or setting up multiple APs, or changing from 2.4Ghz to 5Ghz all seem to trigger this warning with various stack traces.

I'm still seeing this and related warnings on 3.3.0.  At least some
of them comes from calls the 'hostapd' process makes (I printed
current->comm in the warning).

I am not having luck writing a simple script that reproduce this,
but my application that creates a VAP and bunch of virtual station
hits it every time on startup.

Bryan:  Do you have a simple script that reproduces this problem?

Johannes:  Any ideas on likely causes of this problem?  Might help
me zero in on the problem quicker...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

