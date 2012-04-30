Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25278 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab2D3H5Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 03:57:24 -0400
Message-ID: <4F9E45DE.5020805@qca.qualcomm.com> (sfid-20120430_095728_284109_559FBFA4)
Date: Mon, 30 Apr 2012 10:57:18 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 1/2] ath6kl: Update netstats for some of the tx failrues
 in ath6kl_data_tx()
References: <1335452174-7093-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1335452174-7093-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/26/2012 05:56 PM, Vasanthakumar Thiagarajan wrote:
> There are few cases where the tx skb is dropped but netstats is
> not updated, fix this.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, both patches applied.

Kalle
