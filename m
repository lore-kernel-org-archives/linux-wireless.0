Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46431 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab2IUO2e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 10:28:34 -0400
Message-ID: <505C7984.1090600@candelatech.com> (sfid-20120921_162837_476031_17907259)
Date: Fri, 21 Sep 2012 07:28:20 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath9k: Add a debugfs file to adjust antenna diversity
References: <20572.4308.801973.961874@gargle.gargle.HOWL>
In-Reply-To: <20572.4308.801973.961874@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2012 12:01 AM, Sujith Manoharan wrote:
> Location: /<debugfs>/ieee80211/phy#/ath9k/diversity

Can you document what the various settings mean?

Also, what is the difference between antenna diversity
and selecting the tx/rx chainmask?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


