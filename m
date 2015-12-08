Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55230 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbbLHOym (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 09:54:42 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2] ath10k: do not use coherent memory for allocated device memory chunks
References: <1448908321-3042-1-git-send-email-nbd@openwrt.org>
Date: Tue, 8 Dec 2015 16:54:27 +0200
In-Reply-To: <1448908321-3042-1-git-send-email-nbd@openwrt.org> (Felix
	Fietkau's message of "Mon, 30 Nov 2015 19:32:01 +0100")
Message-ID: <87si3d9ejg.fsf@kamboji.qca.qualcomm.com> (sfid-20151208_155444_911775_1845992A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@openwrt.org> writes:

> Coherent memory is more expensive to allocate (and constrained on some
> architectures where it has to be pre-allocated). It is also completely
> unnecessary, since the host has no reason to even access these allocated
> memory spaces
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Applied, thanks.

-- 
Kalle Valo
