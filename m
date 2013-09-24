Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11821 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3IXH3U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Sep 2013 03:29:20 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 0/4] ath10k: improve RX performance
References: <1379335757-15180-1-git-send-email-michal.kazior@tieto.com>
	<87mwn2bu0i.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQnxqgz_90+Q8_FhM6PZh8CEW12dOA+ZGqHeYjK=Bbu9wA@mail.gmail.com>
Date: Tue, 24 Sep 2013 10:29:10 +0300
In-Reply-To: <CA+BoTQnxqgz_90+Q8_FhM6PZh8CEW12dOA+ZGqHeYjK=Bbu9wA@mail.gmail.com>
	(Michal Kazior's message of "Tue, 24 Sep 2013 09:19:50 +0200")
Message-ID: <8761tqbruh.fsf@kamboji.qca.qualcomm.com> (sfid-20130924_092923_772622_6A69FB19)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 24 September 2013 08:42, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> This patchset gives clear RX performance
>>> improvement on AP135. Throughput is at least
>>> doubled (300mbps -> 600mbps, UDP RX, 2x2).
>>>
>>> Patches depend on my RFC patch "mac80211: support
>>> reporting A-MSDU subframes individually".
>>
>> Preferably I can apply these changes only after the mac80211 patch goes
>> to net-next (to avoid unnecessary rebasing). Is there a way to
>> workaround the need for the mac80211 patch in ath10k so that we could
>> apply these patches ASAP? And once the mac80211 patch is commited we
>> could just remove the workaround in ath10k.
>
> The workaround could be to clear the retransmission flag when
> reporting A-MSDU frames individually.

That sounds very good. Can you do that and resend the patchset, please?

-- 
Kalle Valo
