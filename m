Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23827 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964995Ab1GMI0D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 04:26:03 -0400
Message-ID: <4E1D5696.7060108@qca.qualcomm.com> (sfid-20110713_102607_552750_816A7CAD)
Date: Wed, 13 Jul 2011 11:25:58 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <devel@linuxdriverproject.org>,
	<gregkh@suse.de>, <error27@gmail.com>
Subject: Re: [PATCH 15/24] ath6kl: add ieee80211.h
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>	 <20110713013524.8517.92169.stgit@localhost6.localdomain6>	 (sfid-20110713_033533_941292_7CB29E9A) <1310542156.3873.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1310542156.3873.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/13/2011 10:29 AM, Johannes Berg wrote:
> On Wed, 2011-07-13 at 04:35 +0300, Kalle Valo wrote:
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>> ---
>>  drivers/net/wireless/ath/ath6kl/ieee80211.h |  158 +++++++++++++++++++++++++++
> 
> This file shouldn't exist. Anything generic should go to
> include/linux/ieee80211.h, and anything HW specific shouldn't be called
> IEEE80211_*.

Will fix in v2.

Thanks.

Kalle
