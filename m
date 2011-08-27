Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33493 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab1H0G1S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 02:27:18 -0400
Message-ID: <4E588E3B.9000007@openwrt.org> (sfid-20110827_082727_554422_208ADAB4)
Date: Sat, 27 Aug 2011 08:27:07 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k_hw: Set default slottime as 9us
References: <1314424379-1206-1-git-send-email-rmanohar@qca.qualcomm.com>
In-Reply-To: <1314424379-1206-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-27 7:52 AM, Rajkumar Manoharan wrote:
> Initialize 9us slot time as that is what is used mostly
> (for non-ERP cases) and also to be in sync with initvals.
>
> Signed-off-by: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>
Why does it matter, mac80211 tells the driver to reconfigure it anyway. 
Also, why use the stupid ATH9K_SLOT_TIME_* enums? I think we should 
simply remove those.

- Felix
