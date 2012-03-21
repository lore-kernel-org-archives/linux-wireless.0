Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40807 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab2CUPMH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2012 11:12:07 -0400
Message-ID: <4F69EFC2.8030204@candelatech.com> (sfid-20120321_161213_326941_4D7B0332)
Date: Wed, 21 Mar 2012 08:12:02 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 4/4] ath9k:  Support ethtool getstats api.
References: <1332183105-4447-1-git-send-email-greearb@candelatech.com> <1332183105-4447-4-git-send-email-greearb@candelatech.com> <4F684301.9040006@openwrt.org> <4F68B4AA.3070306@candelatech.com> <20329.32334.162938.169995@gargle.gargle.HOWL>
In-Reply-To: <20329.32334.162938.169995@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/21/2012 12:07 AM, Sujith Manoharan wrote:
> Ben Greear wrote:
>> I'd like to gather at least most stats always, so ethtool can work regardless
>> of debugfs.  But, that can be follow on patches in my opinion.  If it turns
>> out that we need another config option for this, then that is fine too.
>
> It would be good to have an option to compile this out. The information is
> available via the debugfs interface, so this is basically duplicating things.
> On APs using OpenWRT, debugfs is enabled by default, so we can just read
> the debugfs files.

Ok.  Hopefully at least the first 3 patches will go in, and when they do
I'll post some more patches for consideration.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
