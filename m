Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52126 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaAaNji (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jan 2014 08:39:38 -0500
Message-ID: <1391175575.4141.10.camel@jlt4.sipsolutions.net> (sfid-20140131_143959_602950_9DBFC4A3)
Subject: Re: [RFC PATCH] net: rfkill: move poll work to power efficient
 workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: Zoran Markovic <zoran.markovic@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, Shaibal Dutta <shaibal.dutta@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>
Date: Fri, 31 Jan 2014 14:39:35 +0100
In-Reply-To: <1391121814-6026-1-git-send-email-zoran.markovic@linaro.org> (sfid-20140130_234406_943564_50677846)
References: <1391121814-6026-1-git-send-email-zoran.markovic@linaro.org>
	 (sfid-20140130_234406_943564_50677846)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-30 at 14:43 -0800, Zoran Markovic wrote:
> From: Shaibal Dutta <shaibal.dutta@broadcom.com>
> 
> This patch moves the rfkill poll_work to the power efficient workqueue.
> This work does not have to be bound to the CPU that scheduled it, hence
> the selection of CPU that executes it would be left to the scheduler.
> Net result is that CPU idle times would be extended, resulting in power
> savings.
> 
> This behaviour is enabled when CONFIG_WQ_POWER_EFFICIENT is selected.

Applied.

johannes

