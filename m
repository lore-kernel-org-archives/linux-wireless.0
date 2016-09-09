Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43814 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750768AbcIINad (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 09:30:33 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
CC: "greearb@candelatech.com" <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH 3/3] ath10k:  Improve logging message.
Date: Fri, 9 Sep 2016 13:30:21 +0000
Message-ID: <87oa3xp5ea.fsf@kamboji.qca.qualcomm.com> (sfid-20160909_153038_347997_0C5890A2)
References: <1471569995-10028-1-git-send-email-greearb@candelatech.com>
        <1471569995-10028-3-git-send-email-greearb@candelatech.com>
        <20160819063511.GA16230@atheros-ThinkPad-T61>
In-Reply-To: <20160819063511.GA16230@atheros-ThinkPad-T61> (Mohammed Shafi
        Shajakhan's message of "Fri, 19 Aug 2016 12:05:11 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@codeaurora.org> writes:

> Hi Ben,
>
> On Thu, Aug 18, 2016 at 06:26:35PM -0700, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>=20
>> Helps to know the sta pointer.
>>=20
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/mac.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireles=
s/ath/ath10k/mac.c
>> index d96c06e..82bc0da 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -6491,8 +6491,8 @@ static int ath10k_sta_state(struct ieee80211_hw *h=
w,
>>  		 * Existing station deletion.
>>  		 */
>>  		ath10k_dbg(ar, ATH10K_DBG_MAC,
>> -			   "mac vdev %d peer delete %pM (sta gone)\n",
>> -			   arvif->vdev_id, sta->addr);
>> +			   "mac vdev %d peer delete %pM (sta gone) sta: %p\n",
>> +			   arvif->vdev_id, sta->addr, sta);
>
> good to rebase over Maharaja's change (%p to %pK)=20
> https://patchwork.kernel.org/patch/9263691/

I added that to the patch in the pending branch.

--=20
Kalle Valo=
