Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:33989 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730AbcC2K4a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2016 06:56:30 -0400
Received: by mail-oi0-f49.google.com with SMTP id o62so16106797oig.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2016 03:56:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABicQ-WPZ39iBc_JVUU-vm2NNCq50rhEKXk6KmqQ7s3-uYgbkQ@mail.gmail.com>
References: <1458547622-1632-1-git-send-email-wnhuang@google.com>
	<87d1qogm50.fsf@kamboji.qca.qualcomm.com>
	<CABicQ-WPZ39iBc_JVUU-vm2NNCq50rhEKXk6KmqQ7s3-uYgbkQ@mail.gmail.com>
Date: Tue, 29 Mar 2016 18:56:29 +0800
Message-ID: <CABicQ-UYpy7JLUntx74Hai93WDpa4uFKNDWQi7788m_jyRL4iA@mail.gmail.com> (sfid-20160329_125649_267855_E36EC014)
Subject: Re: [PATCH] mwifiex: advertise low priority scan feature
From: Wei-Ning Huang <wnhuang@google.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Nishant Sarmukadam <nishants@marvell.com>,
	netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've resent the patch here: https://patchwork.kernel.org/patch/8637861/
Thanks!

Wei-Ning

On Tue, Mar 22, 2016 at 12:12 PM, Wei-Ning Huang <wnhuang@google.com> wrote:
> Hi Kalle,
>
> Thanks for the review. I accidentally removed the s-o-b line from
> akarwar in this version.
> The original patch can be found at:
> https://chromium-review.googlesource.com/#/c/246052/
> I've resent a new one.
>
> Wei-Ning
>
> On Mon, Mar 21, 2016 at 6:28 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Wei-Ning Huang <wnhuang@chromium.org> writes:
>>
>>> From: Amitkumar Karwar <akarwar@marvell.com>
>>>
>>> Low priority scan handling code which delays or aborts scan
>>> operation based on Tx traffic is removed recently. The reason
>>> is firmware already takes care of it in our new feature scan
>>> channel gap. Hence we should advertise low priority scan
>>> support to cfg80211.
>>>
>>> This patch fixes a problem in which OBSS scan request from
>>> wpa_supplicant was being rejected by cfg80211.
>>>
>>> Signed-off-by: Wei-Ning Huang <wnhuang@chromium.org>
>>
>> The From line states that this is written by Amitkumar but there's no
>> Signed-off-By line from him. I can't take this without that, please
>> resend.
>>
>> (Wei-Ning's s-o-b line is correct, I just need also Amitkumar's line.)
>>
>> --
>> Kalle Valo
>
>
>
> --
> Wei-Ning Huang, 黃偉寧 | Software Engineer, Google Inc., Taiwan |
> wnhuang@google.com | Cell: +886 910-380678



-- 
Wei-Ning Huang, 黃偉寧 | Software Engineer, Google Inc., Taiwan |
wnhuang@google.com | Cell: +886 910-380678
