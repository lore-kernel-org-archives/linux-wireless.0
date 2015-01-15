Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:57001 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbbAOIkr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 03:40:47 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21687.32167.596541.729136@gargle.gargle.HOWL> (sfid-20150115_094051_483561_966747C6)
Date: Thu, 15 Jan 2015 14:13:19 +0530
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Make HTT fill size configurable
In-Reply-To: <87mw5kzbog.fsf@kamboji.qca.qualcomm.com>
References: <1420432796-10765-1-git-send-email-sujith@msujith.org>
	<87r3uy4t9y.fsf@kamboji.qca.qualcomm.com>
	<21685.35179.110539.780864@gargle.gargle.HOWL>
	<87bnm01ojf.fsf@kamboji.qca.qualcomm.com>
	<21687.29026.962216.812998@gargle.gargle.HOWL>
	<87vbk8zcr1.fsf@kamboji.qca.qualcomm.com>
	<21687.30578.746681.850817@gargle.gargle.HOWL>
	<87mw5kzbog.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> Yeah, but everyone want higher throughput (including me). So what value
> is best in your opinion?

Lower throughput has been okay for all this time, with a value
of 16. I suppose the value can be retained to not cause regressions
on AP135 or other platforms with a low-powered CPU. As Michal mentioned,
this value allows AP135 to function without the watchdog rebooting
the board.

Sujith
