Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47339 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbbEHNMS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2015 09:12:18 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Eliad Peller <eliad@wizery.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wl18xx: fallback to default conf in case of invalid conf file
References: <1430900994-20509-1-git-send-email-eliad@wizery.com>
Date: Fri, 08 May 2015 16:12:09 +0300
In-Reply-To: <1430900994-20509-1-git-send-email-eliad@wizery.com> (Eliad
	Peller's message of "Wed, 6 May 2015 11:29:54 +0300")
Message-ID: <87ioc3p61i.fsf@kamboji.qca.qualcomm.com> (sfid-20150508_151224_270591_90229B3B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eliad Peller <eliad@wizery.com> writes:

> If the wl18xx-conf.bin file is missing or invalid (e.g. due
> to recent driver change), fallback to default configuration
> instead of failing driver load.
>
> Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Eliad Peller <eliad@wizery.com>

This tells me that wl18xx is doing something wrong. The driver should
still work normally even if user space is old (and vice versa). Should
this configuration file (whatever that even is) have a version number in
file name to handle incompatible changes in a backwards compatible
manner?

But I'm still planning to apply, just wanted to point out this.

-- 
Kalle Valo
