Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22872 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab2ABOIU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 09:08:20 -0500
Message-ID: <4F01B9CF.2020206@qca.qualcomm.com> (sfid-20120102_150824_076786_2C71C04F)
Date: Mon, 2 Jan 2012 19:36:07 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	<m.sujith@gmail.com>, <ath9k-devel@lists.ath9k.org>
Subject: Re: [RFC] ath9k_hw: make use of ar9003_calc_ptr_chksum
References: <1325509985-11720-1-git-send-email-mohammed@qca.qualcomm.com> <4F01B408.1080900@openwrt.org>
In-Reply-To: <4F01B408.1080900@openwrt.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Felix,


On Monday 02 January 2012 07:11 PM, Felix Fietkau wrote:
> On 2012-01-02 2:13 PM, Mohammed Shafi Shajakhan wrote:
>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>
>> make use of the already available function 'ar9003_calc_ptr_chksum'
>> in 'ar9003_set_txdesc'
>>
>> Signed-off-by: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
> NACK. I intentionally did not use that function to avoid unnecessary
> access to uncached memory (for performance reasons).

please explain how it effects the performance and will it cause a 
significant impact

>
> - Felix


-- 
thanks,
shafi
