Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33023 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab1L0QYV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Dec 2011 11:24:21 -0500
Message-ID: <4EF9F0AA.4080404@qca.qualcomm.com> (sfid-20111227_172424_716722_E8B5A1C4)
Date: Tue, 27 Dec 2011 21:52:02 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Marek Lindner <lindner_marek@yahoo.de>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: fix kernel panic in IBSS due to a regression
References: <1324876409-2031-1-git-send-email-mohammed@qca.qualcomm.com> <201112270611.13380.lindner_marek@yahoo.de>
In-Reply-To: <201112270611.13380.lindner_marek@yahoo.de>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 27 December 2011 03:41 AM, Marek Lindner wrote:
> On Monday, December 26, 2011 13:13:29 Mohammed Shafi Shajakhan wrote:
>> kernel panic occurs when we create an IBSS mode and leave it for
>> sometime without any joiner and this is introduced by the
>> commit ec2b774e7c91094d8c00de579646f1162b87b01e where we don't
>> put proper braces for 'list_for_each_entry_safe' and we pass an
>> invalid 'sta' pointer to __sta_info_destroy
>
> I sw this crash too but did not dive into it yet. Thanks!
> Some things are too simple ..  :-)

i took some good time to figure it out, neither obvious to me :-)

>
> Cheers,
> Marek


-- 
thanks,
shafi
