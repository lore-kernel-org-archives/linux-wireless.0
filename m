Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:39179 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbbAOITR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 03:19:17 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21687.30881.260644.741211@gargle.gargle.HOWL> (sfid-20150115_091920_778815_7E119B49)
Date: Thu, 15 Jan 2015 13:51:53 +0530
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Make HTT fill size configurable
In-Reply-To: <21687.30578.746681.850817@gargle.gargle.HOWL>
References: <1420432796-10765-1-git-send-email-sujith@msujith.org>
	<87r3uy4t9y.fsf@kamboji.qca.qualcomm.com>
	<21685.35179.110539.780864@gargle.gargle.HOWL>
	<87bnm01ojf.fsf@kamboji.qca.qualcomm.com>
	<21687.29026.962216.812998@gargle.gargle.HOWL>
	<87vbk8zcr1.fsf@kamboji.qca.qualcomm.com>
	<21687.30578.746681.850817@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan wrote:
> None. The default stays the same. But, it can be adjusted based
> on the platform, if higher throughput is desired.

But, anyway, this patch can be dropped. We'll change the fill level
restriction internally, based on the customer's platform.

Sujith
