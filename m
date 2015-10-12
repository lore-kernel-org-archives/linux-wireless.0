Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:41018 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbbJLFOU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 01:14:20 -0400
From: "Kennady Rajan, Maharaja" <c_mkenna@qti.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] ath10k: Enable adaptive CCA
Date: Mon, 12 Oct 2015 05:14:08 +0000
Message-ID: <e8ed6213bc5a4b458ae865bcaa23b804@APSANEXR01B.ap.qualcomm.com> (sfid-20151012_071448_101142_517F336A)
References: <1444210033-25901-1-git-send-email-c_mkenna@qti.qualcomm.com>
 <87io6gqfgn.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87io6gqfgn.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<c_mkenna@qti.qualcomm.com> writes:

> From: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
>
>> European Union has made it mandatory that all devices working in 2.4 
>> GHz has to adhere to the ETSI specification (ETSI EN 300 328 V1.9.1) 
>> beginnig this year. The standard basically speaks about interferences 
>> in 2.4Ghz band.
>> For example, when 802.11 device detects interference, TX must be 
>> stopped as long as interference is present.
>
>> Adaptive CCA is a feature, when enabled the device learns from the 
>> environment and configures CCA levels adaptively. This will improve 
>> detecting interferences and the device can stop trasmissions till the 
>> interference is present eventually leading to good performances in 
>> varying interference conditions.
>
>> The patch includes code for enabling adaptive CCA for 10.2.4 firmware 
>> on QCA988X.
>
> Signed-off-by: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
> Signed-off-by: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>

>There are conflicts, please rebase and resend:

>Applying: ath10k: Enable adaptive CCA
>Using index info to reconstruct a base tree...
>Falling back to patching base and 3-way merge...
>Auto-merging drivers/net/wireless/ath/ath10k/wmi.h
>Auto-merging drivers/net/wireless/ath/ath10k/wmi.c
>CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi.c
>Auto-merging drivers/net/wireless/ath/ath10k/wmi-ops.h
>CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-ops.h
>Auto-merging drivers/net/wireless/ath/ath10k/mac.c
>Auto-merging drivers/net/wireless/ath/ath10k/core.h
>Failed to merge in the changes.
>Patch failed at 0001 ath10k: Enable adaptive CCA

Sure, I will resend again after rebase.

Regards,
Maha
