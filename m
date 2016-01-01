Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36998 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbcAAKjg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jan 2016 05:39:36 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <aspriel@gmail.com>
Cc: Mathy Vanhoef <vanhoefm@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH 3/7] brcmfmac: Add support for scheduled scan mac randomization
References: <1450100394-17414-1-git-send-email-arend@broadcom.com>
	<1450100394-17414-4-git-send-email-arend@broadcom.com>
	<CAFXAJYwoQRVi_10L5475g1NU5+Abfvv==R6U4P2_rdb=yCPOcw@mail.gmail.com>
	<5685A31F.5020408@gmail.com>
Date: Fri, 01 Jan 2016 12:39:29 +0200
In-Reply-To: <5685A31F.5020408@gmail.com> (Arend van Spriel's message of "Thu,
	31 Dec 2015 22:50:23 +0100")
Message-ID: <87h9ixmvmm.fsf@kamboji.qca.qualcomm.com> (sfid-20160101_114010_549100_698D2265)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <aspriel@gmail.com> writes:

> On 29-12-15 21:47, Mathy Vanhoef wrote:
>> On Mon, Dec 14, 2015 at 2:39 PM, Arend van Spriel <arend@broadcom.com> wrote:
>>> From: Hante Meuleman <meuleman@broadcom.com>
>>>
>>> Scheduled scan be requested to use mac randomization. This patch
>>> checks the flags and enables the randomization if desired.
>> 
>> The driver also needs to advertise support for this using the
>> NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR flag, if the firmware
>> supports it. This can be done in brcmf_setup_wiphy. Otherwise
>> tools like wpa_supplicant won't use randomization.
>
> Indeed. Hante found that out later on and we have a follow-up patch for
> that.
>
> Kalle,
>
> How do you want to treat this? Should I squash the patches into one and
> resubmit or can I just submit follow-up patch.

I would prefer that you squash the patches and resubmit the whole
series.

-- 
Kalle Valo
