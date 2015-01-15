Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:57148 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbbAOM3i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 07:29:38 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH 0/5] ath9k patches
References: <1418951039-12309-1-git-send-email-sujith@msujith.org>
Date: Thu, 15 Jan 2015 14:29:31 +0200
In-Reply-To: <1418951039-12309-1-git-send-email-sujith@msujith.org> (Sujith
	Manoharan's message of "Fri, 19 Dec 2014 06:33:54 +0530")
Message-ID: <87d26gut04.fsf@kamboji.qca.qualcomm.com> (sfid-20150115_133000_202244_3261BA2E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> Pending patches for ath9k, rebased over wireless-drivers-next.
> All of these are for -next.
>
> The patch "ath9k: Fix no-ack frame status" depends on two commits
> that have been merged in mac80211-next, so it needs to be pulled
> into wireless-drivers-next.
>
> Sujith
>
> Miaoqing Pan (4):
>   ath9k: Add HW IDs for QCA956x
>   ath9k: Add initvals for QCA956x
>   ath9k: Fix register definitions for QCA956x
>   ath9k: Add QCA956x HW support

I have applied these patches.

> Sujith Manoharan (1):
>   ath9k: Fix no-ack frame status

This patch is still pending for the mac80211 patch.

-- 
Kalle Valo
