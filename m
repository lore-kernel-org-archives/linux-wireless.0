Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34556 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719AbbBEJRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2015 04:17:33 -0500
Received: by mail-wi0-f179.google.com with SMTP id l15so9111387wiw.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Feb 2015 01:17:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87zj8ut5r4.fsf@kamboji.qca.qualcomm.com>
References: <1422611452-21105-1-git-send-email-michal.kazior@tieto.com>
	<87zj8ut5r4.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 5 Feb 2015 10:17:31 +0100
Message-ID: <CA+BoTQkboueomYd0JNGGtY6S0u_kULCThbX0bSrF0H8rfEZAkA@mail.gmail.com> (sfid-20150205_101738_425719_9CD1CE2C)
Subject: Re: [PATCH] ath10k: add TxBF support
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 February 2015 at 09:55, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> If firmware advertises support for TxBF then the
>> driver has to instruct the firmware accordingly
>> during runtime. Without this patch connecting to
>> an AP with beamformer support would yield abysmal
>> Rx performance.
>>
>> This has been tested with wmi-tlv and qca6174
>> while acting as a STA beamformee only.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> There was a trivial conflict in ath10k_bss_disassoc(), please check my
> conflict resolution in the pending branch.

Looks good, thanks!


Michał
