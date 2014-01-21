Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48540 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448AbaAUM1h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 07:27:37 -0500
Received: by mail-lb0-f174.google.com with SMTP id l4so4225460lbv.5
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jan 2014 04:27:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <874n68g5td.fsf@kamboji.qca.qualcomm.com>
References: <1386858261-16037-1-git-send-email-michal.kazior@tieto.com>
	<874n68g5td.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 21 Jan 2014 13:27:35 +0100
Message-ID: <CADnKcVhYqO-0+_9rN07YZyinjsfdnNnn8ix8FgX457vUw_TWRQ@mail.gmail.com> (sfid-20140121_132752_462667_16EEC237)
Subject: Re: [PATCH 0/3] ath10k: fix host corruption
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 December 2013 16:43, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This patchset aims at fixing (or at least
>> reducing) the frequency of a (apparently) strange
>> HW bug.
>>
>> The bug happens in some workloads with different
>> frequency with different hardware spinoffs. It is
>> triggered by a cold reset after HW/FW has been
>> excercised with some work.
>>
>> On x86 this could be a hang, on AP135 it is a data
>> bus error.
>>
>>
>> Michal Kazior (3):
>>   ath10k: fix device initialization routine
>>   ath10k: zero device DRAM to avoid host hangs
>>   ath10k: zero CE config upon deinit
>
> Let's put these patches on hold for now while we investigate more about
> this problem.
>
> --
> Kalle Valo
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k

Kalle, please drop these patches. There will be new version of this patch-set.

Marek
