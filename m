Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:42118 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaJMFJw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2014 01:09:52 -0400
Received: by mail-wi0-f169.google.com with SMTP id h11so2338053wiw.4
        for <linux-wireless@vger.kernel.org>; Sun, 12 Oct 2014 22:09:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ppe0aurn.fsf@kamboji.qca.qualcomm.com>
References: <1412940780-25360-1-git-send-email-michal.kazior@tieto.com>
	<87ppe0aurn.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 13 Oct 2014 07:09:50 +0200
Message-ID: <CA+BoTQmgg2VvkeETQLyG-x5bqtVqDCf3PZOVbmimbXcHYfV=Ww@mail.gmail.com> (sfid-20141013_070955_484543_864CABAB)
Subject: Re: [PATCH] ath10k: use bss_info as txpower source
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 October 2014 16:01, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This simply changes the source for txpower setup.
>> It does not make ath10k use different txpower
>> values for different vifs.
>>
>> This will make it easier to implement chanctx in
>> ath10k in the future.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> In ath-next-test there was a conflict in ath10k_bss_info_changed().
> Please check my resolution:
>
> https://github.com/kvalo/ath/commit/86eea6fda33ce16a40f98d41c19ea4b0e157f5ba

Looks good, thanks!


Michał
