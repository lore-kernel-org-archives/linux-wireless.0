Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:34296 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbbCIJaD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 05:30:03 -0400
Received: by wesx3 with SMTP id x3so19488903wes.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2015 02:30:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87mw3p1c90.fsf@kamboji.qca.qualcomm.com>
References: <1423749198-11346-1-git-send-email-michal.kazior@tieto.com>
	<1424090094-28164-1-git-send-email-michal.kazior@tieto.com>
	<87mw3p1c90.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 9 Mar 2015 10:30:02 +0100
Message-ID: <CA+BoTQmmcSr7Nm1Z=fVSA9Ak1B3XmixN8Q8C3VBoPmxf3_rN1g@mail.gmail.com> (sfid-20150309_103009_642955_4931FFBF)
Subject: Re: [PATCH v2] ath10k: fix AP/IBSS CSA with template based fw
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 March 2015 at 08:46, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> qca6174 with wmi-tlv firmware uses offloaded
>> beaconing scheme (i.e. templates). This requires a
>> little different approach when implementing CSA.
>>
>> Add missing code to update CS count and report CSA
>> completion to mac80211. Without it channel switch
>> was never finished.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> Thanks, applied.

It seems you've merged v1 instead of v2..  I'll send a follow up fix later.


Michał
