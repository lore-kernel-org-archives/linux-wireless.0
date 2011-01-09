Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39470 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab1AIPfl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 10:35:41 -0500
Received: by iwn9 with SMTP id 9so18522176iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 09 Jan 2011 07:35:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D29C3D1.4020804@openwrt.org>
References: <1294500800-29191-1-git-send-email-greearb@candelatech.com>
	<4D28FF57.9040706@openwrt.org>
	<4D290307.4080807@candelatech.com>
	<4D290450.8070700@openwrt.org>
	<4D290A2C.6040803@candelatech.com>
	<AANLkTim0=1wpPGPDZZzVjO0u_jvv5knA2=v4b-dTfRFq@mail.gmail.com>
	<4D29C3D1.4020804@openwrt.org>
Date: Sun, 9 Jan 2011 16:35:40 +0100
Message-ID: <AANLkTinu9zC3fdMrqmmN__WFd3tMP7Waszp26O2PAtoP@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Implement rx copy-break.
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/1/9 Felix Fietkau <nbd@openwrt.org>:
> On 2011-01-09 7:15 AM, Björn Smedman wrote:
>>
>> I think we should also consider the added stability/saneness with this
>> patch. I for one would be willing to live with some extra cpu load if
>> that means the unstoppable rx dma problem can be contained (all the
>> time).
>
> I don't think this patch has anything to do with the rx dma stop issue.

Ok, so if you have a machine gun that can go off at any time and is
impossible to stop you don't think it makes a difference where it's
pointed? ;) Just kidding, and call me superstitious, but I would feel
much better knowing ath9k is pointing that half-broken dma engine at
it's own data only, at least until it's 100% stable.

/Björn
