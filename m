Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36992 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab0GZWAd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 18:00:33 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id o6QM0Wrl001660
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 26 Jul 2010 15:00:33 -0700
Message-ID: <4C4E0580.3060404@candelatech.com>
Date: Mon, 26 Jul 2010 15:00:32 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: ath9k:  /proc/net/wireless always shows status of 0
References: <4C4DE6B5.5080307@candelatech.com>
In-Reply-To: <4C4DE6B5.5080307@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/26/2010 12:49 PM, Ben Greear wrote:
> This is with today's wireless-testing (with no extra hacks)

Maybe a better question:  In 2.6.31 you could mount debugfs at /debug
and get the state with:
cat /debug/ieee80211/sta0/state

It seems in .34 there is only phy0 info in debugfs.  Or, am I
just not looking in the right place?

I don't mind hacking code, but I'd appreciate a pointer to the
right part of the code if anyone has suggestions.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

