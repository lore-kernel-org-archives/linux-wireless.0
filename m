Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:54628 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab3CMOQQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 10:16:16 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20800.35276.317226.570804@gargle.gargle.HOWL> (sfid-20130313_151620_093058_3BC62D9A)
Date: Wed, 13 Mar 2013 19:44:36 +0530
To: Ben Greear <greearb@candelatech.com>
Cc: Felix Fietkau <nbd@openwrt.org>, ath9k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [RFC] ath9k: Detect and work-around tx-queue hang.
In-Reply-To: <513F70E5.2050004@candelatech.com>
References: <1361498797-14361-1-git-send-email-greearb@candelatech.com>
	<20774.62475.588131.344540@gargle.gargle.HOWL>
	<5126F732.6040007@candelatech.com>
	<20774.63702.208829.602903@gargle.gargle.HOWL>
	<51270186.6070003@candelatech.com>
	<51275837.4020708@openwrt.org>
	<20775.25545.671357.512930@gargle.gargle.HOWL>
	<512766B8.3030008@openwrt.org>
	<51276AA6.4000805@candelatech.com>
	<513F70E5.2050004@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> For instance, is there any good way to know for certain
> if packets in the queue are in power-save or not?  I know
> we at least attempt to disable power-save, but possibly
> it gets re-enabled somehow?

I am not sure if that could happen.

This issue got lost somehow, but reviewing xmit.c would probably
give some clues. :)

Sujith

