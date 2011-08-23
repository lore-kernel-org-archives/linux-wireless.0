Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24727 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab1HWFFK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 01:05:10 -0400
Message-ID: <4E5334FA.3020609@qca.qualcomm.com> (sfid-20110823_070515_415499_63D83E5C)
Date: Tue, 23 Aug 2011 10:34:58 +0530
From: mohammed <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	<linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<rodrigue@qca.qualcomm.com>, <senthilb@qca.qualcomm.com>,
	<rmanohar@qca.qualcomm.com>
Subject: Re: [PATCH] ath9k_htc: Fix few possible memory leaks
References: <1313942085-6238-1-git-send-email-mohammed@qca.qualcomm.com> <20110822052918.GA30951@vasanth-laptop> <4E525FF7.6070904@qca.qualcomm.com> <4E52886C.6050608@lwfinger.net>
In-Reply-To: <4E52886C.6050608@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 22 August 2011 10:18 PM, Larry Finger wrote:
> On 08/22/2011 08:56 AM, mohammed wrote:
>>
>>
>> Vasanth thanks for your review, I haven't and not aware of that code
>> flow/callback. I will check into that.
>>
>
> This patch has helped a lot, but after about 12 hours of running, I
> still have 18 leaks found. I will try to sort them out.

Hi Larry,

thanks for your help, we will also try to find a suitable fix for this.

thanks,
shafi

