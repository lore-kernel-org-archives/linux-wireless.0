Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54457 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab1I2FRt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 01:17:49 -0400
Message-ID: <4E83FF73.4000401@qca.qualcomm.com> (sfid-20110929_071758_276472_69630478)
Date: Thu, 29 Sep 2011 10:47:39 +0530
From: mohammed <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>
Subject: Re: [RFC] ath9k_hw: set is_pciexpress true for AR9480
References: <1317211660-3975-1-git-send-email-mohammed@qca.qualcomm.com> <4E83AC73.3090502@openwrt.org>
In-Reply-To: <4E83AC73.3090502@openwrt.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Felix,

On Thursday 29 September 2011 04:53 AM, Felix Fietkau wrote:
> On 2011-09-28 2:07 PM, Mohammed Shafi Shajakhan wrote:
>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>
>> the AR_SREV register does not seems to indicate it properly though the
>> other information like macVersion etc can be obtained properly
> How about using AR_SREV_9300_20_OR_LATER(ah) instead to make sure that
> this works properly for future chips as well?

this seems to be a problem specifically for AR9480 and this problem does 
not seems to be observed in AR9485. but its needed as if is_pciexpress 
is false ASPM won't be initialized

>
> - Felix

