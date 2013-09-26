Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:42833 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab3IZHpZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 03:45:25 -0400
Received: by mail-bk0-f47.google.com with SMTP id mx12so265379bkb.6
        for <linux-wireless@vger.kernel.org>; Thu, 26 Sep 2013 00:45:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87a9j0t5ep.fsf@kamboji.qca.qualcomm.com>
References: <1380028158-861-1-git-send-email-michal.kazior@tieto.com>
	<87a9j0t5ep.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 26 Sep 2013 09:45:23 +0200
Message-ID: <CA+BoTQke6JstVxtRxUinSxWMP6WDcO3JuqiaXqivSO2QD1aVgw@mail.gmail.com> (sfid-20130926_094529_144993_5244E8B8)
Subject: Re: [PATCH 0/5] ath10k: improve RX performance
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 September 2013 09:21, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This patchset gives clear RX performance
>> improvement on AP135. Throughput is at least
>> doubled (300mbps -> 600mbps, UDP RX, 2x2).
>>
>> This contains a workaround for
>> retransmission/duplication recovery.
>>
>> There's a pending patch for mac80211 that will
>> allow proper individiual A-MSDU subframe
>> reporting.
>>
>> Changes since RFC:
>>  * comments fixes (Kalle)
>>  * one patch extracted/split (Kalle)
>>  * commit message adjustments
>>
>>
>> Michal Kazior (5):
>>   ath10k: report A-MSDU subframes individually
>>   ath10k: document decap modes
>>   ath10k: cleanup RX decap handling
>>   ath10k: fix Native Wifi decap mode RX
>>   ath10k: align RX frames properly
>
> All five applies, thanks.
>
> There were few long lines, I fixed those myself. Can you please double
> check that I didn't break anything?
>
> Kalle
>
> For patch 1 I did:
>
> (...)

Looks good. Thanks!


Michał.
