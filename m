Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59882 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab2AIKHV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 05:07:21 -0500
Date: Mon, 9 Jan 2012 15:37:27 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <stable@kernel.org>,
	Gary Morain <gmorain@google.com>,
	Paul Stewart <pstew@google.com>
Subject: Re: [PATCH] ath9k: Fix regression in bandwidth switch at the same
 channel
Message-ID: <20120109100725.GA1986@vmraj-lnx.users.atheros.com> (sfid-20120109_110726_034200_CAACC175)
References: <1325951457-9218-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1325951457-9218-1-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 07, 2012 at 09:20:57PM +0530, Rajkumar Manoharan wrote:
> The commit "ath9k: Fix invalid noisefloor reading due to channel update"
> preserves the current channel noisefloor readings before updating
> channel type at the same channel index. It also updates the curchan.
> As survey updation refers curchan to get index for updation, that might
> leads to invalid memory access. This patch partially reverts the change
> and stores the noise floor history buffer before updating channel type
> w/o updating curchan.
> 
> Cc: stable@kernel.org
> Cc: Gary Morain <gmorain@google.com>
> Cc: Paul Stewart <pstew@google.com>
> Reported-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
Please ignore this patch. I meant channelwidth not bandwidth. Will send v2 patch
with udpated commit log. Sorry for the inconvenience.

-Rajkumar
