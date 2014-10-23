Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:64493 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaJWNrz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 09:47:55 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] ath10k: speed up recovery
References: <1413807758-30249-1-git-send-email-michal.kazior@tieto.com>
	<CA+BoTQkrUQ6T60qztMuBbjy=vU-4Cho+yBXS051W=fNRTgNeig@mail.gmail.com>
Date: Thu, 23 Oct 2014 16:47:31 +0300
In-Reply-To: <CA+BoTQkrUQ6T60qztMuBbjy=vU-4Cho+yBXS051W=fNRTgNeig@mail.gmail.com>
	(Michal Kazior's message of "Thu, 23 Oct 2014 15:20:28 +0200")
Message-ID: <87k33qq4ng.fsf@kamboji.qca.qualcomm.com> (sfid-20141023_154758_994712_5338512B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 20 October 2014 14:22, Michal Kazior <michal.kazior@tieto.com> wrote:
>> Patch #1 fixes a bug I've found while testing
>> patches #2 and #3. It's safe to cherry-pick it in
>> case patches #2 and/or #3 aren't accepted or need
>> a re-spin.
>>
>> I've mainly used patch #2 to test reset and
>> recovery. It's pretty handy for (stress-)testing.
>>
>> Patch #3 should improve recovery speed in some
>> cases. Notably when there's a long chain of WMI
>> commands involved which take a painfully long time
>> to timeout/complete if firmware crashes mid-way.
>>
>> Note: Patches #2 and #3 depend on `ath10k: pci
>> related fixes 2014-10-09`. Without the patchset
>> patches #2 and #3 must not be applied. Patch #1 is
>> fine though.
>
> Do not apply this patchset yet, please. I need to do a minor fix in
> the 'ath10k: fix possible bmi crash' regarding warm reset patch from
> the other patchset.

Ok, I'm dropping these and will wait for v3.

-- 
Kalle Valo
