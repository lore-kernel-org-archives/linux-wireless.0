Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:38359 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab2K0Nes (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 08:34:48 -0500
Date: Tue, 27 Nov 2012 19:04:57 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Bala Shanmugam <bkamatch@qca.qualcomm.com>
CC: <rodrigue@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>,
	<backports@vger.kernel.org>
Subject: Re: [PATCH 3/3] compat-drivers: Add a crap patch for AR9565
Message-ID: <20121127133455.GA3185@hemis.qca.qualcomm.com> (sfid-20121127_143452_048851_F87876AB)
References: <1353932997-8051-1-git-send-email-bkamatch@qca.qualcomm.com>
 <1353932997-8051-4-git-send-email-bkamatch@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1353932997-8051-4-git-send-email-bkamatch@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 26, 2012 at 05:59:57PM +0530, Bala Shanmugam wrote:
> This patch is required to improve BT throughput to
> meet customer requirement.  This patch is a workaround
> to put WLAN to sleep during BT cycle and cannot be
> upstreamed.
> 
> Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
> ---
>  ...9k-Improve-BT-PAN-FTP-profile-performance.patch |  140 ++++++++++++++++++++
>  1 files changed, 140 insertions(+), 0 deletions(-)
>  create mode 100644 crap/0005-ath9k-Improve-BT-PAN-FTP-profile-performance.patch
>
Luis,

Can you please hold this patch? It needs some more testing.

-Rajkumar
