Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:35152 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab3IBF3w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Sep 2013 01:29:52 -0400
Received: by mail-bk0-f48.google.com with SMTP id my13so1364484bkb.7
        for <linux-wireless@vger.kernel.org>; Sun, 01 Sep 2013 22:29:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87zjrx6ob5.fsf@kamboji.qca.qualcomm.com>
References: <1377068249-26025-1-git-send-email-michal.kazior@tieto.com>
	<1377601683-12072-1-git-send-email-michal.kazior@tieto.com>
	<87zjrx6ob5.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 2 Sep 2013 07:29:50 +0200
Message-ID: <CA+BoTQk+T6VrwhDLZfpOy=XFPCsP7V5W8DhpxND-geUWds6wrQ@mail.gmail.com> (sfid-20130902_072956_249972_ED64DB02)
Subject: Re: [PATCH v2 0/6] ath10k: CE cleanups
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 September 2013 08:36, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This patchset contains non-functional changes
>> except patch #1 which changes memory allocation
>> from dynamic to static.
>>
>> There is still some more to clean up in PCI/CE
>> but it's probably better to keep patchsets compact
>> and more frequent.
>>
>> v2:
>>  * fix checkpatch warning (Kalle)
>>
>>
>> Michal.
>>
>>
>> Michal Kazior (6):
>>   ath10k: use inline ce_state structure
>>   ath10k: remove ce_op_state
>>   ath10k: remove unused ce_attr parameters
>>   ath10k: rename hif_ce_pipe_info to ath10k_pci_pipe
>>   ath10k: rename ce_state to ath10k_ce_pipe
>>   ath10k: rename ce_ring_state to ath10k_ce_ring
>
> Applied all six, thanks.
>
> I dropped the lock addition from patch 1 and patch 5 had a conflict due
> to that change. Please double check that I didn't break anything.

Looks good, thanks! Sorry for the trouble.


Michał.
