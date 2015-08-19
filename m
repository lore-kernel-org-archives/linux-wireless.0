Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:43692 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbbHSV7f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 17:59:35 -0400
Message-ID: <55D4FC40.4020905@broadcom.com> (sfid-20150819_235939_002090_05317C4D)
Date: Wed, 19 Aug 2015 23:59:28 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 2/7] brcmfmac: correct interface combination info
References: <1439708139-7527-1-git-send-email-arend@broadcom.com>	<1439708139-7527-3-git-send-email-arend@broadcom.com> <CACna6ryYkWOufztYgA6dhYkUUrLPC+05m2UX1J89uS8eha=YYQ@mail.gmail.com>
In-Reply-To: <CACna6ryYkWOufztYgA6dhYkUUrLPC+05m2UX1J89uS8eha=YYQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/19/2015 11:49 PM, Rafał Miłecki wrote:
> On 16 August 2015 at 08:55, Arend van Spriel <arend@broadcom.com> wrote:
>> The interface combination provided by brcmfmac did not truly reflect
>> the combinations supported by driver and/or firmware.
>
> This is OK in general but may conflict a bit with my recent:
> brcmfmac: set wiphy's addresses to provide valid MACs

Actually had to dive into firmware and the mask on ea[5] is determined 
by allowed number of AP interfaces by MBSS.

Regards,
Arend

> My implementation was designed for a one combo only, I'll submit a fix for that.
>

