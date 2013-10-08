Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64296 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab3JHTJ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 15:09:58 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: fix station authorization
References: <1380875428-20899-1-git-send-email-michal.kazior@tieto.com>
	<8761t7sibr.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 8 Oct 2013 22:09:52 +0300
In-Reply-To: <8761t7sibr.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Tue, 8 Oct 2013 21:55:52 +0300")
Message-ID: <87wqlnr33z.fsf@kamboji.qca.qualcomm.com> (sfid-20131008_211001_469558_C12826B5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> Peer authorization should be delayed until
>> mac80211 says given station has transitioned into
>> authorized state.
>>
>> The state is propagated from mac80211 for both
>> open and protected networks.
>>
>> This should prevent data traffic to/from given
>> station until authorization completes. Until now
>> it was probably possible for unauthorized traffic
>> to pass leading to possible security issues.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> Thanks, applied.

Actually I'll take this back. After this patch even ping doesn't work
with D-Link DIR-865L as AP using 10.1.389 firmware. So I have to drop
this patch.

-- 
Kalle Valo
