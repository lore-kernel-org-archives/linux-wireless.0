Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:62127 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3LBID0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 03:03:26 -0500
Received: by mail-we0-f174.google.com with SMTP id q58so11427350wes.5
        for <linux-wireless@vger.kernel.org>; Mon, 02 Dec 2013 00:03:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87wqjnbsw0.fsf@kamboji.qca.qualcomm.com>
References: <1385737763-10481-1-git-send-email-bartosz.markowski@tieto.com>
	<87wqjnbsw0.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 2 Dec 2013 09:03:25 +0100
Message-ID: <CACKGw+HBo5RxiyLp8zJ7tySMu=B6YkELUso_ZTjpmFq26U0jeA@mail.gmail.com> (sfid-20131202_090329_910759_980F6755)
Subject: Re: [PATCH] ath10k: fix multi BSSID with WPA on FW 10.1
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 December 2013 08:42, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Bartosz Markowski <bartosz.markowski@tieto.com> writes:
>
>> From: Michal Kazior <michal.kazior@tieto.com>
>>
>> FW 10.1 seems to require the default key index to
>> be updated to point to group key after it is
>> installed. Otherwise Txed frames are corrupted.
>>
>> Tested-by: Tomasz Skapski <tomasz.skapski@tieto.com>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> I see few checkpatch warnings:
>
> drivers/net/wireless/ath/ath10k/mac.c:2721: ERROR: code indent should use tabs where possible
> drivers/net/wireless/ath/ath10k/mac.c:2722: ERROR: code indent should use tabs where possible
> drivers/net/wireless/ath/ath10k/mac.c:2723: ERROR: code indent should use tabs where possible

ouch, sorry for that. I'll send a v2 in a sec.

-- 
Bartosz
