Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:56110 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaLXRT2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 12:19:28 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	thomas@net.t-labs.tu-berlin.de
Subject: Re: [PATCH 0/3] add debugfs support to ath9k hw TPC
References: <1418944694-10614-1-git-send-email-lorenzo.bianconi83@gmail.com>
Date: Wed, 24 Dec 2014 19:19:21 +0200
In-Reply-To: <1418944694-10614-1-git-send-email-lorenzo.bianconi83@gmail.com>
	(Lorenzo Bianconi's message of "Fri, 19 Dec 2014 00:18:11 +0100")
Message-ID: <87tx0l6k4m.fsf@kamboji.qca.qualcomm.com> (sfid-20141224_181931_399921_3F6C1FE6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi83@gmail.com> writes:

> *[PATCH 1/3]: enable TPC by default on AR9003 based chips
> *[PATCH 2/3]: enable/disable hw TPC through debugfs
> *[PATCH 3/3]: fix typo
>
> Lorenzo Bianconi (3):
>   ath9k: enable TPC by default
>   ath9k: add debugfs support for hw TPC
>   ath9k: fix typo

Thanks, all three applied to wireless-drivers-next.git.

-- 
Kalle Valo
