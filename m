Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:21571 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbbCIMZm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 08:25:42 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: fix AP/IBSS CSA with template based fw
References: <1423749198-11346-1-git-send-email-michal.kazior@tieto.com>
	<1424090094-28164-1-git-send-email-michal.kazior@tieto.com>
	<87mw3p1c90.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQmmcSr7Nm1Z=fVSA9Ak1B3XmixN8Q8C3VBoPmxf3_rN1g@mail.gmail.com>
Date: Mon, 9 Mar 2015 14:25:33 +0200
In-Reply-To: <CA+BoTQmmcSr7Nm1Z=fVSA9Ak1B3XmixN8Q8C3VBoPmxf3_rN1g@mail.gmail.com>
	(Michal Kazior's message of "Mon, 9 Mar 2015 10:30:02 +0100")
Message-ID: <877fuqz7b6.fsf@kamboji.qca.qualcomm.com> (sfid-20150309_132546_847274_C0C1BB31)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 7 March 2015 at 08:46, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> qca6174 with wmi-tlv firmware uses offloaded
>>> beaconing scheme (i.e. templates). This requires a
>>> little different approach when implementing CSA.
>>>
>>> Add missing code to update CS count and report CSA
>>> completion to mac80211. Without it channel switch
>>> was never finished.
>>>
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>
>> Thanks, applied.
>
> It seems you've merged v1 instead of v2..  I'll send a follow up fix later.

Oh, sorry about that. Please do send a followup patch.

-- 
Kalle Valo
