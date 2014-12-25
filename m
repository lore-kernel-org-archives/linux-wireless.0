Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:64539 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaLYVpq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Dec 2014 16:45:46 -0500
Received: by mail-ie0-f176.google.com with SMTP id tr6so8655484ieb.7
        for <linux-wireless@vger.kernel.org>; Thu, 25 Dec 2014 13:45:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5499BDE9.7020807@broadcom.com>
References: <1419357863-2018-1-git-send-email-arend@broadcom.com>
	<5499BDE9.7020807@broadcom.com>
Date: Thu, 25 Dec 2014 22:45:45 +0100
Message-ID: <CACna6rwixzmSNe3FFp_NcTuJPcJ35RmxJ8z90ejL+JvsP4f58Q@mail.gmail.com> (sfid-20141225_225316_662515_1EE62FC1)
Subject: Re: [PATCH V2 3/10] brcmfmac: Add support for bcm43340/1 wireless chipsets
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Rob Herring <rob.herring@linaro.org>,
	John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 December 2014 at 20:09, Arend van Spriel <arend@broadcom.com> wrote:
> On 12/23/14 19:04, Arend van Spriel wrote:
>>
>> This patch adds support for the bcm43340 and bcm43341 wireless
>> chipsets. These two chipsets are identical from wireless parts
>> perspective. As such they use the same firmware image.
>
>
> Kalle,
>
> Just curious. Would this patch have ended up on [1] when I would have filled
> In-Reply-to: properly during git send-email? If so I can add that to our
> internal process description.

I tried it few times (with OpenWrt and MIPS or MTD) and it didn't work for me.

However there is different thing you can do to help handling patches.
When you send a new version, you can sign in to the patchwork and mark
old version as superseded.
