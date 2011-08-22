Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15476 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab1HVN7a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 09:59:30 -0400
Message-ID: <4E5260BC.8040402@qca.qualcomm.com> (sfid-20110822_155933_892611_F069F6B1)
Date: Mon, 22 Aug 2011 19:29:24 +0530
From: mohammed <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<rodrigue@qca.qualcomm.com>, <senthilb@qca.qualcomm.com>,
	<rmanohar@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: Re: [RFC] mac80211: Add a debug entry to track last beacon
References: <1313941417-5446-1-git-send-email-mohammed@qca.qualcomm.com> <4E512B0D.1040109@qca.qualcomm.com>
In-Reply-To: <4E512B0D.1040109@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 21 August 2011 09:28 PM, mohammed wrote:
> On Sunday 21 August 2011 09:13 PM, Mohammed Shafi Shajakhan wrote:
>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>
>> when we obtain time_since_last_beacon_ms parameter from the mac80211
>> debugfs it should be always less than 100, otherwise we are missing
>> beacons.
>
> made a mistake in the commit-log
> 'time_since_last_beacon_ms' should be always less than the configured
> beacon interval in the AP, otherwise we are missing beacons


also the case of station not getting associated should be taken care. 
will sending a proper patch addressing the above two. thanks!

>
>>
>> Signed-off-by: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>
