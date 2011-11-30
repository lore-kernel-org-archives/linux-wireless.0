Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4520 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab1K3HOX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 02:14:23 -0500
Message-ID: <4ED5D723.2060106@qca.qualcomm.com> (sfid-20111130_081427_038323_C3222C40)
Date: Wed, 30 Nov 2011 12:41:31 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: validate for non-zero BSSID
References: <1322576540-13751-1-git-send-email-mohammed@qca.qualcomm.com>	<20111130023650.19520.qmail@stuge.se>	<4ED5BD76.7020204@qca.qualcomm.com> <8739d6gl7s.fsf@purkki.adurom.net>
In-Reply-To: <8739d6gl7s.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 30 November 2011 12:17 PM, Kalle Valo wrote:
> Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>  writes:
>
>> unassociated state for station.
>>
>> but I observed this when i tested ad-hoc mode. I just started an
>> ad-hoc mode creator and left it for some time with no one joining. i
>> observed there are few frames in rx_tasklet of ath9k driver which seem
>> to be beacons and their BSSID is '0', as our curbssid is also '0' they
>> seem to be wrongly identified as 'my_beacons'.
>
> This is a perfect addition to the commit log. Remember that the commit
> log should especially answer the question "why?".
>
Kalle, thanks. I will properly test this in STA and IBSS mode, and add 
this commit log.

-- 
thanks,
shafi
