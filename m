Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:56549 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbaLXRhF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 12:37:05 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"Rob Herring" <rob.herring@linaro.org>,
	John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH V2 3/10] brcmfmac: Add support for bcm43340/1 wireless chipsets
References: <1419357863-2018-1-git-send-email-arend@broadcom.com>
	<5499BDE9.7020807@broadcom.com>
Date: Wed, 24 Dec 2014 19:36:59 +0200
In-Reply-To: <5499BDE9.7020807@broadcom.com> (Arend van Spriel's message of
	"Tue, 23 Dec 2014 20:09:29 +0100")
Message-ID: <87mw6d6jb8.fsf@kamboji.qca.qualcomm.com> (sfid-20141224_183724_368124_58B87C75)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> On 12/23/14 19:04, Arend van Spriel wrote:
>> This patch adds support for the bcm43340 and bcm43341 wireless
>> chipsets. These two chipsets are identical from wireless parts
>> perspective. As such they use the same firmware image.
>
> Kalle,
>
> Just curious. Would this patch have ended up on [1] when I would have
> filled In-Reply-to: properly during git send-email? If so I can add
> that to our internal process description.

Not sure, I'm not very familiar with patchwork yet. I saw some
documentation that it's possible to update the patch with pwclient, but
I haven't seen anything about doing it via email.

IMHO it's just best to resend the whole series even if just one patch
needs changes. Anything else would be just confusing and error prone.

-- 
Kalle Valo
