Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:44508 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbbALN0m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 08:26:42 -0500
Received: by mail-wg0-f43.google.com with SMTP id k14so19238743wgh.2
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2015 05:26:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87d26kdvt1.fsf@kamboji.qca.qualcomm.com>
References: <1420715550-16017-1-git-send-email-michal.kazior@tieto.com>
	<87d26kdvt1.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 12 Jan 2015 14:26:34 +0100
Message-ID: <CA+BoTQ=3oY4hrotrNcNVP9AUMM1E_DayC25O0f_iD+oJ1d2LSQ@mail.gmail.com> (sfid-20150112_142646_179634_6C8CB5B7)
Subject: Re: [PATCH v2 0/5] ath10k: implement beacon offload
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 January 2015 at 13:31, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
[...]
>> Michal Kazior (5):
>>   ath10k: implement new beacon tx status event
>>   ath10k: implement beacon template command
>>   ath10k: implement prb tmpl wmi command
>>   ath10k: implement p2p bcn ie command
>>   ath10k: implement support for ap beacon offloading
>
> While applying this I had few trivial commits with wmi ops. Can you
> double check my resolution from ath-next-test, please? (It might take an
> hour before I push the patches.)
>
> Pushing patch "ath10k-implement-new-beacon-tx" ... done
> Pushing patch "ath10k-implement-beacon-templa" ...
>   CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi.c
>   CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-tlv.c
>   CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-ops.h
> Error: The merge failed during "push".
>        Revert the operation with "stg undo".
> stg rebase: 3 conflict(s)

Looks good, thanks!


Michał
