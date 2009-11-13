Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:35800 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267AbZKMROf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 12:14:35 -0500
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 Nov 2009 09:14:41 -0800
Date: Fri, 13 Nov 2009 09:14:38 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH 2/2] ath9k_hw: Fix AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB
	and its shift value in 0x4054
Message-ID: <20091113171438.GD3865@tux>
References: <1258102960-22768-1-git-send-email-vasanth@atheros.com> <1258102960-22768-2-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1258102960-22768-2-git-send-email-vasanth@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 13, 2009 at 01:02:40AM -0800, Vasanth Thiagarajan wrote:
> The bit value of AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB is wrong, it should
> be 0x400 and the number of bits to be right shifted is 10. Having this
> wrong value in 0x4054 sometimes affects bt quality on btcoex environment.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>

These both seem small enough and reasonable for stable fixes no?
Although I didn't get the impact of the first one..

  Luis
