Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33058 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab1LSQHK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 11:07:10 -0500
Subject: Re: [PATCH] ath6kl: Support for TCP checksum offload to firmware
From: Johannes Berg <johannes@sipsolutions.net>
To: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath6kl-devel@qualcomm.com
In-Reply-To: <1324173631-14594-2-git-send-email-rpanjwan@qca.qualcomm.com> (sfid-20111218_030109_052671_48E505EC)
References: <1324173631-14594-1-git-send-email-rpanjwan@qca.qualcomm.com>
	 <1324173631-14594-2-git-send-email-rpanjwan@qca.qualcomm.com>
	 (sfid-20111218_030109_052671_48E505EC)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Dec 2011 17:07:07 +0100
Message-ID: <1324310827.3414.8.camel@jlt3.sipsolutions.net> (sfid-20111219_170713_839884_94F31CE5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-12-17 at 18:00 -0800, Rishi Panjwani wrote:
> To enable TCP checksum offload, at the time of loading the ath6kl
> driver, add 'csum_offload=1' to the load instruction as follows:
> insmod ath6kl_sdio.ko csum_offload=1

NACK. ethtool exists.

johannes

