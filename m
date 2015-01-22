Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:38939 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbbAVNy6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 08:54:58 -0500
Received: by mail-la0-f54.google.com with SMTP id hv19so1665522lab.13
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2015 05:54:57 -0800 (PST)
Message-ID: <54C1012F.1020400@cogentembedded.com> (sfid-20150122_145504_903491_AC344680)
Date: Thu, 22 Jan 2015 16:54:55 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>,
	"Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
CC: brudley@broadcom.com, Arend van Spriel <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>, meuleman@broadcom.com,
	linville@tuxdriver.com, pieterpg@broadcom.com, hdegoede@redhat.com,
	wens@csie.org, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com, netdev@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcmfmac: avoid duplicated suspend/resume operation
References: <54BDCC06.8090107@linux.intel.com> <87twzincvz.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87twzincvz.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 1/22/2015 4:49 PM, Kalle Valo wrote:

>> >From 04d3fa673897ca4ccbea6c76836d0092dba2484a Mon Sep 17 00:00:00 2001
>> From: Zhonghui Fu <zhonghui.fu@linux.intel.com>
>> Date: Tue, 20 Jan 2015 11:14:13 +0800
>> Subject: [PATCH] brcmfmac: avoid duplicated suspend/resume operation

>> WiFi chip has 2 SDIO functions, and PM core will trigger
>> twice suspend/resume operations for one WiFi chip to do
>> the same things. This patch avoid this case.

>> Acked-by: Arend van Spriel <arend@broadcom.com>
>> Acked-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>> Acked-by: Kalle Valo <kvalo@codeaurora.org>
>> Signed-off-by: Zhonghui Fu <zhonghui.fu@linux.intel.com>

> I don't remember giving Acked-by to this (or for matter to anything for
> a long time). What about Sergei or Arend?

    I haven't ACK'ed this patch either.

WBR, Sergei

