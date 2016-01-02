Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37069 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbcABI2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2016 03:28:53 -0500
Received: by mail-wm0-f49.google.com with SMTP id f206so153040689wmf.0
        for <linux-wireless@vger.kernel.org>; Sat, 02 Jan 2016 00:28:53 -0800 (PST)
Subject: Re: [PATCH 3/7] brcmfmac: Add support for scheduled scan mac
 randomization
To: Kalle Valo <kvalo@codeaurora.org>
References: <1450100394-17414-1-git-send-email-arend@broadcom.com>
 <1450100394-17414-4-git-send-email-arend@broadcom.com>
 <CAFXAJYwoQRVi_10L5475g1NU5+Abfvv==R6U4P2_rdb=yCPOcw@mail.gmail.com>
 <5685A31F.5020408@gmail.com> <87h9ixmvmm.fsf@kamboji.qca.qualcomm.com>
Cc: Mathy Vanhoef <vanhoefm@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
From: Arend van Spriel <aspriel@gmail.com>
Message-ID: <56878A42.7010506@gmail.com> (sfid-20160102_092918_803283_64AA1729)
Date: Sat, 2 Jan 2016 09:28:50 +0100
MIME-Version: 1.0
In-Reply-To: <87h9ixmvmm.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01-01-16 11:39, Kalle Valo wrote:
> Arend van Spriel <aspriel@gmail.com> writes:
> 
>> On 29-12-15 21:47, Mathy Vanhoef wrote:
>>> On Mon, Dec 14, 2015 at 2:39 PM, Arend van Spriel <arend@broadcom.com> wrote:
>>>> From: Hante Meuleman <meuleman@broadcom.com>
>>>>
>>>> Scheduled scan be requested to use mac randomization. This patch
>>>> checks the flags and enables the randomization if desired.
>>>
>>> The driver also needs to advertise support for this using the
>>> NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR flag, if the firmware
>>> supports it. This can be done in brcmf_setup_wiphy. Otherwise
>>> tools like wpa_supplicant won't use randomization.
>>
>> Indeed. Hante found that out later on and we have a follow-up patch for
>> that.
>>
>> Kalle,
>>
>> How do you want to treat this? Should I squash the patches into one and
>> resubmit or can I just submit follow-up patch.
> 
> I would prefer that you squash the patches and resubmit the whole
> series.

Ok, thanks. Prepared that already.

Regards,
Arend
