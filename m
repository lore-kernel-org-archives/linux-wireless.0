Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:35436 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbbCaLWy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2015 07:22:54 -0400
Received: by lahf3 with SMTP id f3so9615241lah.2
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2015 04:22:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87iodi4oex.fsf@kamboji.qca.qualcomm.com>
References: <1427271291-31683-1-git-send-email-janusz.dziedzic@tieto.com>
	<87iodi4oex.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 31 Mar 2015 13:22:53 +0200
Message-ID: <CAFED-jmARkKvUemR-rOT8JG2nZad3ctm674QGUqcSXeFw32zqQ@mail.gmail.com> (sfid-20150331_132258_367758_4103A52C)
Subject: Re: [PATCH] ath10k: disable burst mode
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-03-30 15:15 GMT+02:00 Kalle Valo <kvalo@qca.qualcomm.com>:
> Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:
>
>> Firmwares that indicate BURST_SERVICE as enabled
>> could overwrite some wmm parameters (eg. txop).
>> This could lead IOT and balancing issues.
>> Hence disable this by default.
>>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>
> There was a trivial conflict, please check my resolution in the pending
> branch.
>
Looks good. Thanks

BR
Janusz
