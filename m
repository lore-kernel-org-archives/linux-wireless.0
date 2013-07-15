Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:42798 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab3GOJGe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 05:06:34 -0400
Received: by mail-lb0-f177.google.com with SMTP id 10so9112559lbf.36
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jul 2013 02:06:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87mwpop93v.fsf@kamboji.qca.qualcomm.com>
References: <1373624746-3244-1-git-send-email-janusz.dziedzic@tieto.com>
	<87mwpop93v.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 15 Jul 2013 11:06:31 +0200
Message-ID: <CALhHN=pGFRS8CW31vq0gRAmos-yPRVUffVi_QibbNVLq7x-ObA@mail.gmail.com> (sfid-20130715_110649_703072_E6D6427E)
Subject: Re: [PATCH] ath10k: pass also QOS Null frames through mgmt tx path
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  On 15 July 2013 09:37, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:
>
>> Fw will report wrong tx status for QOS Null frames
>> sent through data tx path.
>>
>> This patch fixes station(s) keep alive detection
>> triggered from wpa_supplicant/hostapd when work
>> as AP/GO and WMM enabled.
>>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>
> I think you mentioned privately that this patch should be dropped. Is
> that still the case?
>

Yes, please drop this patch

BR
Janusz
