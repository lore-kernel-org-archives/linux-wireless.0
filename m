Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33526 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab2BMR0F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 12:26:05 -0500
Message-ID: <4F3947A1.2060103@candelatech.com> (sfid-20120213_182612_794156_6ED3E47D)
Date: Mon, 13 Feb 2012 09:25:53 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH 3/7] ath9k: Merge wiphy and misc debugfs files
References: <20280.43962.403799.188541@gargle.gargle.HOWL>
In-Reply-To: <20280.43962.403799.188541@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/12/2012 10:20 PM, Sujith Manoharan wrote:
> This patch merges the 'wiphy' and 'misc' debugfs files
> and consolidates the information.
>
> Information about the current channel and other HT parameters
> can be obtained from both mac80211 and iw. Remove such
> redundant data.

It is nice to be able to see what the driver/NIC thinks
it is set to as well.  It is always possible that the
stack and the NIC are out of sync for some reason.
I'd rather those values be left in the debugfs unless
there is a good reason for getting rid of them.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

