Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58055 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbaJ0Io5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 04:44:57 -0400
Received: by mail-wi0-f172.google.com with SMTP id d1so2098751wiv.17
        for <linux-wireless@vger.kernel.org>; Mon, 27 Oct 2014 01:44:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87siieom8s.fsf@kamboji.qca.qualcomm.com>
References: <1414073150-11593-1-git-send-email-bartosz.markowski@tieto.com>
	<87siieom8s.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 27 Oct 2014 09:44:56 +0100
Message-ID: <CACKGw+FBM8jV+ctYK=3D+oBWLYEv6snG_sOSZ-wbmwUFs5v-KA@mail.gmail.com> (sfid-20141027_094500_388292_43C8A5F5)
Subject: Re: [PATCH] ath10k: fix pm resume after suspend
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 October 2014 17:10, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Bartosz Markowski <bartosz.markowski@tieto.com> writes:
>
>> Firmware was crashing when we were trying to warm reset it
>> after suspend. This was due to the fact that target registeres
>> can be accessed only if the hardware is awaken.
>>
>> This patch makes sure to awake the device also on the hif up,
>> not only in case of probe call path.
>>
>> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
>
> This one has non-trivial conflicts. Can you rebase, please?

Sure, I've sent a PATCH v2.

-- 
Bartosz
