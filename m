Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:10226 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaHSJtt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 05:49:49 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix wmi service bitmap debug
References: <1406628239-31322-1-git-send-email-michal.kazior@tieto.com>
	<87y4uuqhip.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQmTvcLDWeKnRXKnAVh27DGrvk+xgr_9DFmuZ3gA6yedYw@mail.gmail.com>
Date: Tue, 19 Aug 2014 12:49:40 +0300
In-Reply-To: <CA+BoTQmTvcLDWeKnRXKnAVh27DGrvk+xgr_9DFmuZ3gA6yedYw@mail.gmail.com>
	(Michal Kazior's message of "Tue, 19 Aug 2014 09:46:07 +0200")
Message-ID: <87bnrgbyh7.fsf@kamboji.qca.qualcomm.com> (sfid-20140819_114952_707704_882761F3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 12 August 2014 09:44, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> The 10.x and main firmware branches have
>>> conflicting WMI service bitmap definitions.
>>>
>>> This also fixes WMI services parsing on big-endian
>>> hosts and changes debugfs output to be more human
>>> friendly.
>>>
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>
>> Thanks, applied.
>
> Your tree has wmi_10x_svc_map() and wmi_main_svc_map() swapped[1][2].
> This results in invalid wmi service mappings.

Doh.

> Did you have a conflict on this patch?

Maybe, I can't really remember anymore. I'm always supposed to mention
about conflicts separately, but maybe I forgot this time? Can you send a
followup patch to fix this, please?

-- 
Kalle Valo
