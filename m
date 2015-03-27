Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:41444 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbbC0Rn4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2015 13:43:56 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: Re: [PATCH v4 6/6] ath10k: introduce basic tdls functionality
References: <1426849379-7562-1-git-send-email-marek.puzyniak@tieto.com>
	<1426849379-7562-7-git-send-email-marek.puzyniak@tieto.com>
	<CADnKcVhg8ZVD8Nn7pqjtCUWWOiO_8Zp7-U0zaMh4FKL-pj3bLg@mail.gmail.com>
Date: Fri, 27 Mar 2015 19:43:38 +0200
In-Reply-To: <CADnKcVhg8ZVD8Nn7pqjtCUWWOiO_8Zp7-U0zaMh4FKL-pj3bLg@mail.gmail.com>
	(Marek Puzyniak's message of "Fri, 27 Mar 2015 10:33:56 -0400")
Message-ID: <87iodm72ut.fsf@kamboji.qca.qualcomm.com> (sfid-20150327_184359_942951_754925EF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marek Puzyniak <marek.puzyniak@tieto.com> writes:

> Hi Kalle,
>
> On 20 March 2015 at 07:02, Marek Puzyniak <marek.puzyniak@tieto.com> wrote:
>> This patch introduces tdls without tdls peer uapsd
>> and tdls channel switching.
>> Transmitting tdls data frames works only for ethernet
>> type frames, that's why data addressed to tdls sta
>> is in ethernet format.
>>
>> This patch depends on:
>> mac80211: initialize rate control earlier for tdls station
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>
>> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
>> ---
> [...]
>
>> +static int ath10_mac_tdls_vifs_count(struct ieee80211_hw *hw)
> [...]
>> +               num_tdls_vifs = ath10_mac_tdls_vifs_count(hw);
> [...]
>
> I found typo in my patch. This can be fixed by

Thanks, I fixed this directly in the pending branch.

-- 
Kalle Valo
