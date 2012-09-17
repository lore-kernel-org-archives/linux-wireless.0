Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6361 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab2IQPNI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2012 11:13:08 -0400
Message-ID: <50573DDE.2060502@qca.qualcomm.com> (sfid-20120917_171313_526953_21DB337C)
Date: Mon, 17 Sep 2012 20:42:30 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Thomas Wagner <thomas.wagner@hs-rm.de>
CC: Felix Fietkau <nbd@openwrt.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	<ath9k-devel@venema.h4ckr.net>,
	Javier Cardona <javier@cozybit.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath9k: Fix mesh related rx filtering issue for older
 chips
References: <1347634168-20706-1-git-send-email-mohammed@qca.qualcomm.com> <50534AE3.3060107@openwrt.org> <1518263.XlGm7EvTdD@buri> <5056B274.5050901@qca.qualcomm.com>
In-Reply-To: <5056B274.5050901@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tom,


On Monday 17 September 2012 10:47 AM, Mohammed Shafi Shajakhan wrote:
> Hi Tom,
>
> + linux-wireless
>
> On Saturday 15 September 2012 12:24 AM, Thomas Wagner wrote:
>> Hi,
>>
>>> I'm really not sure about this being tied to sc->nvifs.
>>> If it's mesh related, how about just adding a check for the number of
>>> mesh interfaces [...]
>> No, it is not mesh related!
>> Several frames where filtered out.
>> I discovered this on trying to set up a mesh.
>> But the where filtered frames beyond  the mesh: e.g. a beacon of
>> 802.11b Sitecom Router
>>
>> @Felix: Pleas forward this mail to:
>> linux-wireless@vger.kernel.org
>> ath9k-devel@venema.h4ckr.net
>>
>>
>
> thanks for the clarification.
>
>

will send a v3 soon changing the subject and commit log mentioning 
generically that the  older hardware chipsets seem to filter some 
necessary wifi frames ?. thanks!


-- 
thanks,
shafi


