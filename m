Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35580 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbbLaVuU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Dec 2015 16:50:20 -0500
Received: by mail-wm0-f43.google.com with SMTP id f206so72218288wmf.0
        for <linux-wireless@vger.kernel.org>; Thu, 31 Dec 2015 13:50:20 -0800 (PST)
Subject: Re: [PATCH 3/7] brcmfmac: Add support for scheduled scan mac
 randomization
To: Mathy Vanhoef <vanhoefm@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
References: <1450100394-17414-1-git-send-email-arend@broadcom.com>
 <1450100394-17414-4-git-send-email-arend@broadcom.com>
 <CAFXAJYwoQRVi_10L5475g1NU5+Abfvv==R6U4P2_rdb=yCPOcw@mail.gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
From: Arend van Spriel <aspriel@gmail.com>
Message-ID: <5685A31F.5020408@gmail.com> (sfid-20151231_225024_089837_BC1DE502)
Date: Thu, 31 Dec 2015 22:50:23 +0100
MIME-Version: 1.0
In-Reply-To: <CAFXAJYwoQRVi_10L5475g1NU5+Abfvv==R6U4P2_rdb=yCPOcw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 29-12-15 21:47, Mathy Vanhoef wrote:
> On Mon, Dec 14, 2015 at 2:39 PM, Arend van Spriel <arend@broadcom.com> wrote:
>> From: Hante Meuleman <meuleman@broadcom.com>
>>
>> Scheduled scan be requested to use mac randomization. This patch
>> checks the flags and enables the randomization if desired.
> 
> The driver also needs to advertise support for this using the
> NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR flag, if the firmware
> supports it. This can be done in brcmf_setup_wiphy. Otherwise
> tools like wpa_supplicant won't use randomization.

Indeed. Hante found that out later on and we have a follow-up patch for
that.

Kalle,

How do you want to treat this? Should I squash the patches into one and
resubmit or can I just submit follow-up patch.

Regards,
Arend

> Kr,
> Mathy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
