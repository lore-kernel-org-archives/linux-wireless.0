Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:38785 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbbAHUK1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2015 15:10:27 -0500
Message-ID: <54AEE430.2070706@broadcom.com> (sfid-20150108_211032_033004_3839D0D0)
Date: Thu, 8 Jan 2015 21:10:24 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	<ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH] ath: ath9k: use debugfs_create_devm_seqfile() helper
 for seq_file entries
References: <1419685980-4728-1-git-send-email-arend@broadcom.com>	<87bnmapiur.fsf@kamboji.qca.qualcomm.com> <21677.63268.657151.679992@gargle.gargle.HOWL>
In-Reply-To: <21677.63268.657151.679992@gargle.gargle.HOWL>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/08/15 04:19, Sujith Manoharan wrote:
>> Arend van Spriel<arend@broadcom.com>  writes:
>>
>>> Use the helper to get rid of the file operations per debugfs file. The
>>> device driver data contains struct ieee80211_hw pointer and the
>>> struct ath9k_softc pointer is assigned to ieee80211_hw::priv so it can
>>> be accessed in the seq_file read operation.
>>>
>>> Cc: ath9k-devel@lists.ath9k.org
>>> Signed-off-by: Arend van Spriel<arend@broadcom.com>
>
> Thanks for the patch.
>
>> Can someone with ath9k hardware test this, please? I'm hesitant to apply
>> this without testing.
>
> I tested it and there were no crashes.

Thanks, Sujith

So the content of the modified debugfs files looks sane?

Regards,
Arend

> Sujith

