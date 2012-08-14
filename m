Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17848 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2HNE44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2012 00:56:56 -0400
Message-ID: <5029DA90.8040403@qca.qualcomm.com> (sfid-20120814_065700_467494_BA010DAD)
Date: Tue, 14 Aug 2012 10:26:48 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>
Subject: Re: [RFC 1/3] ath9k: cleanup add_iterface/change_interface
References: <1344871278-6499-1-git-send-email-mohammed@qca.qualcomm.com> <20521.7840.420228.712856@gargle.gargle.HOWL>
In-Reply-To: <20521.7840.420228.712856@gargle.gargle.HOWL>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sujith,

On Monday 13 August 2012 09:04 PM, Sujith Manoharan wrote:
> Mohammed Shafi Shajakhan wrote:
>> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>>
>> All these checks will be handled by cfg80211 based on
>> the interface combination advertized. For instance
>> we support 8 beacon while we advertize maximum 8
>> beaconing interface in the interface combination
>> support, also cfg80211 will take care of not allowing
>> us to add an interface that is not supported by the
>> driver, so as if the change_interface changes the
>> old interface to a beaconing interface where we had
>> reached the maximum number of beacoing interface
>
> This looks good.

thanks for the review!

>
> Sujith
>


-- 
thanks,
shafi


