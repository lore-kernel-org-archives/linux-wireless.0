Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56873 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab2ILN0L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2012 09:26:11 -0400
Date: Wed, 12 Sep 2012 18:55:51 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/5] ath9k_hw: move 2g5g switch before nfcal start
Message-ID: <20120912132549.GA7481@vmraj-lnx.qca.qualcomm.com> (sfid-20120912_152616_891769_988BDA0B)
References: <1347432833-10343-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1347432833-10343-1-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 12, 2012 at 12:23:49PM +0530, Rajkumar Manoharan wrote:
> During fast channel change, perform 2g5g_switch before starting
> noisefloor calibration to avoid nfload timeout.
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/hw.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
John,

Please drop this series. I'll send v2 patchset. Sorry for inconvenience.

-Rajkumar
