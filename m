Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46256 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752200AbcJCMet (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Oct 2016 08:34:49 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] rtl8xxxu: Fix big-endian problem reporting mactime
References: <1475178055-16924-1-git-send-email-Jes.Sorensen@redhat.com>
        <1475178055-16924-3-git-send-email-Jes.Sorensen@redhat.com>
        <87shsdsxj9.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 03 Oct 2016 08:34:47 -0400
In-Reply-To: <87shsdsxj9.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Mon, 03 Oct 2016 10:26:50 +0300")
Message-ID: <wrfjint93920.fsf@redhat.com> (sfid-20161003_143453_063908_2188A87E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:
> Jes.Sorensen@redhat.com writes:
>
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> The full RX descriptor is converted so converting tsfl again would
>> return it to it's original endian value.
>>
>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> I'll add:
>
> Cc: stable@vger.kernel.org # 4.8+

Appreciate it!

Jes
