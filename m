Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:33007 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174Ab0H3K5w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 06:57:52 -0400
To: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl1251: Fix queue stopping/waking for TX path
References: <1282945699-25472-1-git-send-email-GNUtoo@no-log.org>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 30 Aug 2010 13:57:50 +0300
In-Reply-To: <1282945699-25472-1-git-send-email-GNUtoo@no-log.org> (Denis Carikli's message of "Fri\, 27 Aug 2010 23\:48\:19 +0200")
Message-ID: <87tymc74gh.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Denis 'GNUtoo' Carikli <GNUtoo@no-log.org> writes:

> This patch was adapted from 06f7bc7db79fabe6b2ec16eff0f59e4acc21eb72
> (from linus's linux-2.6 tree of kernel.org)
>
> here's the original message:
>     The queue stopping/waking functionality was broken in a way that could
>     cause huge latencies in TX transfers and even cause the TX to stall in the
>     right circumstances. Correct these problems.
>
> Signed-off-by: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>

Acked-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
