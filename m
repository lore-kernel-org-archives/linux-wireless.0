Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61111 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753845AbdDEIsc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 04:48:32 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Marcin Rokicki <marcin.rokicki@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath10k: Clean header files from bad block comments
Date: Wed, 5 Apr 2017 08:48:26 +0000
Message-ID: <87zifvi6jp.fsf@kamboji.qca.qualcomm.com> (sfid-20170405_105213_033938_06395B6F)
References: <1487601530-22932-1-git-send-email-marcin.rokicki@tieto.com>
        <744f9259075b4d0784712a5cd272024e@euamsexm01a.eu.qualcomm.com>
In-Reply-To: <744f9259075b4d0784712a5cd272024e@euamsexm01a.eu.qualcomm.com>
        (Kalle Valo's message of "Wed, 5 Apr 2017 09:45:39 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Marcin Rokicki <marcin.rokicki@tieto.com> wrote:
>> Fix output from checkpatch.pl like:
>>  Block comments use a trailing */ on a separate line
>>=20
>> Signed-off-by: Marcin Rokicki <marcin.rokicki@tieto.com>
>
> Patch applied to ath-next branch of ath.git, thanks.
>
> 37ff1b0df37a ath10k: clean header files from bad block comments

I also enabled the checkpatch warning in ath10k-check so that we can
catch any new warnings:

https://github.com/qca/qca-swiss-army-knife/commit/e23fbd3c9647c20e29e819b8=
a6d934e1b56067b9

--=20
Kalle Valo=
