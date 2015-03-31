Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38244 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbbCaKhQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2015 06:37:16 -0400
Received: by wibgn9 with SMTP id gn9so20323561wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2015 03:37:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87iodi318p.fsf@kamboji.qca.qualcomm.com>
References: <1427200993-7550-1-git-send-email-michal.kazior@tieto.com>
	<1427200993-7550-3-git-send-email-michal.kazior@tieto.com>
	<87iodi318p.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 31 Mar 2015 12:37:15 +0200
Message-ID: <CA+BoTQkouPcREDVpKx=iKs05aeoAUv8Qj-keO3FPVdOyojyDnQ@mail.gmail.com> (sfid-20150331_123721_696350_DEAD3AE2)
Subject: Re: [PATCH v5 2/7] ath10k: implement chanctx API
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 March 2015 at 18:21, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> The chanctx API will allow ath10k to support
>> multi-channel operation.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> kbuild reports:
>
> sparse warnings: (new ones prefixed by >>)
>
>>> drivers/net/wireless/ath/ath10k/mac.h:72:57: sparse: incorrect type in initializer (different address spaces)
>    drivers/net/wireless/ath/ath10k/mac.h:72:57:    expected struct ieee80211_chanctx_conf *conf
>    drivers/net/wireless/ath/ath10k/mac.h:72:57:    got struct ieee80211_chanctx_conf [noderef] <asn:4>*chanctx_conf
>>> drivers/net/wireless/ath/ath10k/mac.h:72:57: sparse: incorrect type in initializer (different address spaces)
[...]

Thanks for catching this! I've sent a v6.

Btw. I'm puzzled why my sparse isn't helpful like this. Ideas?


Michał
