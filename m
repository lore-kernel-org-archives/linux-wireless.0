Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2595 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab3K0Ozi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 09:55:38 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] ath10k: use nss provided by mac80211
References: <1385126819-15311-1-git-send-email-michal.kazior@tieto.com>
	<1385474260-22385-1-git-send-email-michal.kazior@tieto.com>
	<1385474260-22385-2-git-send-email-michal.kazior@tieto.com>
	<CA+BoTQmtkBGpktbLRfmiLuLDKP9TnUeWu4OMeGUsVcq7m05u4Q@mail.gmail.com>
Date: Wed, 27 Nov 2013 16:55:32 +0200
In-Reply-To: <CA+BoTQmtkBGpktbLRfmiLuLDKP9TnUeWu4OMeGUsVcq7m05u4Q@mail.gmail.com>
	(Michal Kazior's message of "Wed, 27 Nov 2013 11:25:45 +0100")
Message-ID: <87ppplgahm.fsf@kamboji.qca.qualcomm.com> (sfid-20131127_155541_822371_2BB8035A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 26 November 2013 14:57, Michal Kazior <michal.kazior@tieto.com> wrote:
>> Calculating STA NSS just from the mcs rateset is
>> not the greatest idea.
>>
>> This should prevent connectivity issues if
>> mac80211 is ever to set rx_nss to something other
>> rather than base on max mcs map. As an example
>> operation mode change notification in assoc
>> request may change rx_nss initial values in the
>> future.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
>
> Drop this single patch, please.
>
> I just noticed rx_nss doesn't seem to have correct value when associating..

Ok, I'm dropping this.

-- 
Kalle Valo
