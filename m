Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:31435 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757212AbbBEL4r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2015 06:56:47 -0500
Message-ID: <54D35A76.4010801@linux.intel.com> (sfid-20150205_125708_023460_A6AF255D)
Date: Thu, 05 Feb 2015 19:56:38 +0800
From: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: brudley@broadcom.com, Arend van Spriel <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>, meuleman@broadcom.com,
	linville@tuxdriver.com, pieterpg@broadcom.com, hdegoede@redhat.com,
	wens@csie.org, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com, netdev@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcmfmac: avoid duplicated suspend/resume operation
References: <54C5AA8C.4010005@linux.intel.com> <87vbjjw3bc.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87vbjjw3bc.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 2015/2/3 21:08, Kalle Valo wrote:
> "Fu, Zhonghui" <zhonghui.fu@linux.intel.com> writes:
>
>> >From ff39ed4af9f1c50358fe92ec4c8eaac9db183e00 Mon Sep 17 00:00:00 2001
>> From: Zhonghui Fu <zhonghui.fu@linux.intel.com>
>> Date: Mon, 26 Jan 2015 10:13:21 +0800
>> Subject: [PATCH] brcmfmac: avoid duplicated suspend/resume operation
>>
>> WiFi chip has 2 SDIO functions, and PM core will trigger
>> twice suspend/resume operations for one WiFi chip to do
>> the same things. This patch avoid this case.
>>
>> Acked-by: Arend van Spriel<arend@broadcom.com>
>> Signed-off-by: Zhonghui Fu <zhonghui.fu@linux.intel.com>
> This doesn't apply:
>
> Applying: brcmfmac: avoid duplicated suspend/resume operation
> Using index info to reconstruct a base tree...
> Falling back to patching base and 3-way merge...
> Auto-merging drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> CONFLICT (content): Merge conflict in drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> Failed to merge in the changes.
> Patch failed at 0001 brcmfmac: avoid duplicated suspend/resume operation
>
> BTW, when you resend a patch please use "[PATCH v2]" (or v3, v4...) in
> the Subject field.
Just see your comments, so please ignore my inquiry in last mail. I will re-base this patch again.


Thanks,
Zhonghui

