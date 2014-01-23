Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:56911 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaAWMyi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 07:54:38 -0500
Received: by mail-la0-f50.google.com with SMTP id ec20so1437031lab.9
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jan 2014 04:54:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87zjmm50ve.fsf@kamboji.qca.qualcomm.com>
References: <1390477701-16843-1-git-send-email-marek.puzyniak@tieto.com>
	<87zjmm50ve.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 23 Jan 2014 13:54:35 +0100
Message-ID: <CADnKcVh7WcxwhRpep0nhm5G2P=OZE47Qof-9BH=HcQ+UA=COyg@mail.gmail.com> (sfid-20140123_135443_081601_646116A0)
Subject: Re: [PATCH v2] ath10k: implement and use new beacon method
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 January 2014 13:38, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Marek Puzyniak <marek.puzyniak@tieto.com> writes:
>
>> From: Michal Kazior <michal.kazior@tieto.com>
>>
>> Until now ath10k used a copy-by-value beacon
>> submission.
>>
>> The new method passes a DMA address via WMI
>> command only. This command contains additional
>> metadata that fixes AP behaviour with regard
>> to powersave buffering.
>>
>> This also fixes strange bug when multicast traffic
>> would freeze TX indefinitely.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
>> ---
>>
>> v2:
>>  -rebased,
>>  -beacon send function refactored,
>>  -comments moved before field in structure declaration.
>
> I had a conflict when I was applying this to ath-next-test branch for
> pending patches. Can you please double check that I didn't break
> anything:
>
> https://github.com/kvalo/ath/commit/311f8996ada0e9ff94d5b122b1f022b72e0cdb39
It is OK.
>
> --
> Kalle Valo
Marek
