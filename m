Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44195 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbbG2JeG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 05:34:06 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Vivek Natarajan <nataraja@qti.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Support different txbf configuration schemes
References: <1437395401-2765-1-git-send-email-nataraja@qti.qualcomm.com>
Date: Wed, 29 Jul 2015 12:33:57 +0300
In-Reply-To: <1437395401-2765-1-git-send-email-nataraja@qti.qualcomm.com>
	(Vivek Natarajan's message of "Mon, 20 Jul 2015 18:00:00 +0530")
Message-ID: <87zj2f5muy.fsf@kamboji.qca.qualcomm.com> (sfid-20150729_113411_947395_82F698B1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <nataraja@qti.qualcomm.com> writes:

> qca61x4 uses the vdev param as a sole sufficient configuration
> for txbf while qca99x0 enables txbf during peer assoc by
> combining the vdev param value with peer assoc's vht capabilities
>
> This patch gets the appropriate txbf configuration scheme
> before passing the wmi command to enable the same in the firmware.
>
> Signed-off-by: Vivek Natarajan <nataraja@qti.qualcomm.com>

The patches don't apply anymore and as they lacking proper sha1 ids I
cannot fix the conflicts myself, so please rebase. Please always use
ath.git master branch without _any_ extra patches because that way I can
usually fix conflicts myself with the help of 3-way merge.

Applying: ath10k: Support different txbf configuration schemes
fatal: sha1 information is lacking or useless (drivers/net/wireless/ath/ath10k/mac.c).
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0001 ath10k: Support different txbf configuration schemes

-- 
Kalle Valo
