Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:21385 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbaJFRCT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 13:02:19 -0400
Date: Mon, 6 Oct 2014 22:34:01 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: Re: [PATCH 1/2] ath10k: add tracepoint for htt tx frames
Message-ID: <20141006170400.GB362@qca.qualcomm.com> (sfid-20141006_190223_212615_1A8EACFB)
References: <1412614118-17205-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1412614118-17205-1-git-send-email-rmanohar@qti.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 06, 2014 at 10:18:37PM +0530, Rajkumar Manoharan wrote:
> Although frame contents were printed via dbg_dump
> already it was not possible to easily filter them
> out for processing.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/htt_tx.c |  3 ++-
>  drivers/net/wireless/ath/ath10k/trace.h  | 13 +++++++++----
>  2 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
> index fdfb171..9621b62 100644

Oops. I can merge these two patches it seems..

Kalle,

Please ignore this series.

-Rajkumar
