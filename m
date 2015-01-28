Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:39824 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbbA2BIN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2015 20:08:13 -0500
Received: by mail-wi0-f179.google.com with SMTP id l15so17773124wiw.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2015 17:08:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87h9vb9uzo.fsf@kamboji.qca.qualcomm.com>
References: <1421749440-10457-1-git-send-email-michal.kazior@tieto.com>
	<87h9vb9uzo.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 28 Jan 2015 09:49:47 +0100
Message-ID: <CA+BoTQkbN1jM22KO+BP9L+E8GCfp6QssTa2xD2G=gy7WOe4MAg@mail.gmail.com> (sfid-20150129_020853_905527_8F714D8D)
Subject: Re: [PATCH 1/2] ath10k: implement sta keepalive command
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 January 2015 at 09:20, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>>
>> New wmi-tlv firmware for qca6174 has STA keepalive
>> service available. The service can provide
>> automatic idle connection polling via NullFunc
>> frames to AP when acting as a client.
>>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> I had a trivial conflict, please check my resolution from the pending
> branch:
>
> Applying: ath10k: implement sta keepalive command
> Using index info to reconstruct a base tree...
> Falling back to patching base and 3-way merge...
> Auto-merging drivers/net/wireless/ath/ath10k/wmi.h
> Auto-merging drivers/net/wireless/ath/ath10k/wmi-tlv.h
> CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-tlv.h
> Auto-merging drivers/net/wireless/ath/ath10k/wmi-tlv.c
> CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-tlv.c
> Auto-merging drivers/net/wireless/ath/ath10k/wmi-ops.h
> CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi-ops.h
> Failed to merge in the changes.
> Patch failed at 0001 ath10k: implement sta keepalive command

Looks good. Thanks!


Michał
