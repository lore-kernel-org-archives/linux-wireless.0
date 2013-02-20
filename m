Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50378 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757746Ab3BTKIz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 05:08:55 -0500
Message-ID: <1361354928.8629.17.camel@jlt4.sipsolutions.net> (sfid-20130220_110906_640334_BAA70538)
Subject: Re: [PATCH 1/1] net: rfkill: Fix sparse warning in
 rfkill-regulator.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	davem@davemloft.net, linville@tuxdriver.com
Date: Wed, 20 Feb 2013 11:08:48 +0100
In-Reply-To: <1361267868-2316-1-git-send-email-sachin.kamat@linaro.org> (sfid-20130219_110850_873316_C9085702)
References: <1361267868-2316-1-git-send-email-sachin.kamat@linaro.org>
	 (sfid-20130219_110850_873316_C9085702)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-19 at 15:27 +0530, Sachin Kamat wrote:
> 'rfkill_regulator_ops' is used only in this file. Hence make it static.
> Silences the following warning:
> net/rfkill/rfkill-regulator.c:54:19: warning:
> symbol 'rfkill_regulator_ops' was not declared. Should it be static?

I'll take this, but it isn't going anywhere until the merge window opens
again.

johannes

