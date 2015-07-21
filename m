Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39022 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbbGUPGp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 11:06:45 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Guy Mishol <guym@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wl18xx: add dynamic fw traces
References: <1436957897-27602-1-git-send-email-guym@ti.com>
Date: Tue, 21 Jul 2015 18:06:40 +0300
In-Reply-To: <1436957897-27602-1-git-send-email-guym@ti.com> (Guy Mishol's
	message of "Wed, 15 Jul 2015 13:58:17 +0300")
Message-ID: <87fv4hmtxb.fsf@kamboji.qca.qualcomm.com> (sfid-20150721_170657_647880_43D269E1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Guy Mishol <guym@ti.com> writes:

> add option to dynamically configure the fw
> which debug traces to open
>
> Signed-off-by: Guy Mishol <guym@ti.com>

Failed to apply, please rebase:

Applying: wl18xx: add dynamic fw traces
fatal: sha1 information is lacking or useless
(drivers/net/wireless/ti/wl18xx/acx.c).
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0001 wl18xx: add dynamic fw traces

-- 
Kalle Valo
