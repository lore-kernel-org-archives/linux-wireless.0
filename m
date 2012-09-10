Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50902 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab2IJFZv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 01:25:51 -0400
Date: Mon, 10 Sep 2012 10:56:33 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath9k_hw: Wait BT calibration to complete
Message-ID: <20120910052632.GA20286@vmraj-lnx.qca.qualcomm.com> (sfid-20120910_072558_103150_E11FF99F)
References: <1346823135-2992-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1346823135-2992-1-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 05, 2012 at 11:02:13AM +0530, Rajkumar Manoharan wrote:
> Whenever BT calibration requested, WLAN has to wait for the
> calibration to be completed. But right now we defer the waiting
> which might cause BT calibration to fail. Fix that.
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_mci.c |  1 +
>  drivers/net/wireless/ath/ath9k/debug.h      |  1 -
>  drivers/net/wireless/ath/ath9k/mci.c        | 19 ++++++++++++++++++-
>  3 files changed, 19 insertions(+), 2 deletions(-)
John,

This patch conflicts with -rc5. I'll will resend v2 patchset.

-Rajkumar
