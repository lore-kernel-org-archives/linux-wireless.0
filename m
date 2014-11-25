Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:53878 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaKYF1S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 00:27:18 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21620.5017.657509.251220@gargle.gargle.HOWL> (sfid-20141125_062903_241616_4C129D88)
Date: Tue, 25 Nov 2014 10:58:57 +0530
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: Fix shared WEP
In-Reply-To: <87lhn0639s.fsf@kamboji.qca.qualcomm.com>
References: <1416796657-24657-1-git-send-email-sujith@msujith.org>
	<1416796657-24657-2-git-send-email-sujith@msujith.org>
	<87lhn0639s.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> No magic numbers, please. I didn't find anything for IV internals from
> ieee80211.h, not sure if we should add them there or just use ath10k
> internal defines.

We are just retrieving the keyidx from the IV - not sure adding a couple
of macros for "6" and "3" will make any difference.

Sujith
