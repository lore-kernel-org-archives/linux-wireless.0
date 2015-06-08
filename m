Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39855 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbbFHHJK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 03:09:10 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jakub Kicinski <moorray3@wp.pl>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jakub Kicinski <kubakici@wp.pl>
Subject: Re: [PATCH 1/4] mt7601u: unify paged and non-paged RX dma paths
References: <1433272288-6450-1-git-send-email-moorray3@wp.pl>
Date: Mon, 08 Jun 2015 10:09:03 +0300
In-Reply-To: <1433272288-6450-1-git-send-email-moorray3@wp.pl> (Jakub
	Kicinski's message of "Tue, 2 Jun 2015 21:11:25 +0200")
Message-ID: <87k2vellrk.fsf@kamboji.qca.qualcomm.com> (sfid-20150608_090914_829525_E8BE12A9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jakub Kicinski <moorray3@wp.pl> writes:

> From: Jakub Kicinski <kubakici@wp.pl>
>
> Signed-off-by: Jakub Kicinski <kubakici@wp.pl>

No need to change anything now but in the future please avoid empty
commit logs. And at some point I'll start automatically rejecting
patches with empty commit logs so better get used to this already now.

-- 
Kalle Valo
