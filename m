Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:34404 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab2IUSQ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 14:16:26 -0400
Message-ID: <505CAEE4.7000906@candelatech.com> (sfid-20120921_201630_066463_12CEB71B)
Date: Fri, 21 Sep 2012 11:16:04 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath9k: Add a debugfs file to adjust antenna diversity
References: <20572.4308.801973.961874@gargle.gargle.HOWL> <505C7984.1090600@candelatech.com> <20572.39015.872732.569065@gargle.gargle.HOWL>
In-Reply-To: <20572.39015.872732.569065@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2012 09:40 AM, Sujith Manoharan wrote:
> Ben Greear wrote:
>> Can you document what the various settings mean?
>
> 1 = Enable, 0 = Disable. :)
>
>> Also, what is the difference between antenna diversity
>> and selecting the tx/rx chainmask?
>
> Diversity is used to select which antenna to receive on based on RSSI.
> (See antenna.c)

Ok, that sounds interesting.

With the chainmask stuff, it turns out it was bad to set it through
debugfs...  Can diversity be enabled/disabled through debugfs
without worry?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

