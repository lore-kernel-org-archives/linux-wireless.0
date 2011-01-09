Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53817 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab1AIOTF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 09:19:05 -0500
Message-ID: <4D29C3D1.4020804@openwrt.org>
Date: Sun, 09 Jan 2011 07:18:57 -0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k: Implement rx copy-break.
References: <1294500800-29191-1-git-send-email-greearb@candelatech.com>	<4D28FF57.9040706@openwrt.org>	<4D290307.4080807@candelatech.com>	<4D290450.8070700@openwrt.org>	<4D290A2C.6040803@candelatech.com> <AANLkTim0=1wpPGPDZZzVjO0u_jvv5knA2=v4b-dTfRFq@mail.gmail.com>
In-Reply-To: <AANLkTim0=1wpPGPDZZzVjO0u_jvv5knA2=v4b-dTfRFq@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-01-09 7:15 AM, Björn Smedman wrote:
> I think we should also consider the added stability/saneness with this
> patch. I for one would be willing to live with some extra cpu load if
> that means the unstoppable rx dma problem can be contained (all the
> time).
I don't think this patch has anything to do with the rx dma stop issue.

- Felix
