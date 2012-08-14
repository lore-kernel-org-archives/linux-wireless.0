Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39358 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2HNFCb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2012 01:02:31 -0400
Message-ID: <5029DBE0.4040603@qca.qualcomm.com> (sfid-20120814_070235_114695_C89B3E1E)
Date: Tue, 14 Aug 2012 10:32:24 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>
Subject: Re: [RFC 2/3] ath9k_htc: Advertise interface combinations supported
References: <1344871339-6575-1-git-send-email-mohammed@qca.qualcomm.com> <20521.8011.624016.146590@gargle.gargle.HOWL>
In-Reply-To: <20521.8011.624016.146590@gargle.gargle.HOWL>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sujith,

On Monday 13 August 2012 09:07 PM, Sujith Manoharan wrote:
> Mohammed Shafi Shajakhan wrote:
>> +static const struct ieee80211_iface_limit if_limits[] = {
>> +	{ .max = 2,	.types = BIT(NL80211_IFTYPE_STATION) |
>> +				 BIT(NL80211_IFTYPE_P2P_CLIENT) },
>> +	{ .max = 2,	.types =
>> +			BIT(NL80211_IFTYPE_AP) |
>> +			BIT(NL80211_IFTYPE_P2P_GO) },
>> +};
>
> Well, P2P-GO/AP modes etc. are just broken in ath9k_htc.. but the patch could
> go in, I guess. If you can fix the weird indentation. :)
>

thanks for the review, i will fix that. The weird indentation may be 
because i copied the code from init.c in ath9k :)
may be we could later fix P2P-GO/AP mode, concurrency in ath9k_htc!

-- 
thanks,
shafi


