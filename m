Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:8059 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbaKXK7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 05:59:14 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Vivek Natarajan <nataraja@qti.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/2] ath10k: Do not limit RTS threshold value to 2347
References: <1416821930-3003-1-git-send-email-nataraja@qti.qualcomm.com>
Date: Mon, 24 Nov 2014 12:59:08 +0200
In-Reply-To: <1416821930-3003-1-git-send-email-nataraja@qti.qualcomm.com>
	(Vivek Natarajan's message of "Mon, 24 Nov 2014 15:08:49 +0530")
Message-ID: <87a93g7tkz.fsf@kamboji.qca.qualcomm.com> (sfid-20141124_115925_622311_0AFB8A69)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <nataraja@qti.qualcomm.com> writes:

> Signed-off-by: Vivek Natarajan <nataraja@qti.qualcomm.com>

Please no patches with empty commit logs.

Also please send ath10k patches both to ath10k and linux-wireless lists.
This is important especially now that I'm experimenting with patchwork
and it won't see the patch otherwise.

Documentation is here:

http://wireless.kernel.org/en/users/Drivers/ath10k/sources#Submitting_patches

-- 
Kalle Valo
