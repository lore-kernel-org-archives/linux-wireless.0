Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46194 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab2EWHSw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 03:18:52 -0400
Message-ID: <4FBC8F55.3080509@qca.qualcomm.com> (sfid-20120523_091855_893592_F9D8EF89)
Date: Wed, 23 May 2012 10:18:45 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Fix missing gpio pin 9 configuration
References: <1337671370-32519-1-git-send-email-vthiagar@qca.qualcomm.com> <4FBC8EBF.20404@qca.qualcomm.com>
In-Reply-To: <4FBC8EBF.20404@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/23/2012 10:16 AM, Vasanthakumar Thiagarajan wrote:
> On Tuesday 22 May 2012 12:52 PM, Vasanthakumar Thiagarajan wrote:
>> GPIO pin 9 also needs to be configured along with other gpio
>> pins to avoid sdio crc errors. I've not experienced any issue
>> with missing this particular gpio pin configuration, found dunring
>> code review. This can potentially improve rx performance.
>>
>> Signed-off-by: Vasanthakumar Thiagarajan<vthiagar@qca.qualcomm.com>
>
> I hope you are not dropping this one along with the other
> series of two patches sent mistakenly. This is genuine patch.

No, I didn't. I was just busy with something else, will review soon.

Kalle
