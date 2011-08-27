Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54931 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773Ab1H0HEo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 03:04:44 -0400
Message-ID: <4E589704.3090807@openwrt.org> (sfid-20110827_090455_656197_1A0C06C2)
Date: Sat, 27 Aug 2011 09:04:36 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k_hw: Set default slottime as 9us
References: <1314424379-1206-1-git-send-email-rmanohar@qca.qualcomm.com> <4E588E3B.9000007@openwrt.org> <20110827065256.GA3082@vmraj-lnx.users.atheros.com>
In-Reply-To: <20110827065256.GA3082@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-27 8:52 AM, Rajkumar Manoharan wrote:
> On Sat, Aug 27, 2011 at 08:27:07AM +0200, Felix Fietkau wrote:
>>  On 2011-08-27 7:52 AM, Rajkumar Manoharan wrote:
>>  >Initialize 9us slot time as that is what is used mostly
>>  >(for non-ERP cases) and also to be in sync with initvals.
>>  >
>>  >Signed-off-by: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>
>>  Why does it matter, mac80211 tells the driver to reconfigure it
>>  anyway. Also, why use the stupid ATH9K_SLOT_TIME_* enums? I think we
>>  should simply remove those.
>>
> In most of the case, mac80211 set as 9us and also initval uses 9us.
> The what is the problem of setting 9us as default. If you want to
> remove ATH9K_SLOT_TIME_* enums, ath9k should not set slottime till
> it got configured.
I don't see a problem with the change aside from the fact that it should 
not make any difference at all, so I don't really see any point to it.

- Felix
