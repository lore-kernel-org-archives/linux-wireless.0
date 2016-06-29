Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39516 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbcF2Pr2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 11:47:28 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wlcore: sdio: Fix crash on wlcore_probe_of when failing to
 parse/map irq
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1465519606-68129-1-git-send-email-bruherrera@gmail.com>
To: Bruno Herrera <bruherrera@gmail.com>
Cc: poggi.raph@gmail.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20160629154623.3A94D61367@smtp.codeaurora.org> (sfid-20160629_174805_990019_A49146EA)
Date: Wed, 29 Jun 2016 15:46:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bruno Herrera <bruherrera@gmail.com> wrote:
> pdev_data pointer is being freed with kfree but the pointer is not dynamic allocated.
> 
> Signed-off-by: Bruno Herrera <bruherrera@gmail.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

6edc119ed3b5 wlcore: sdio: Fix crash on wlcore_probe_of when failing to parse/map irq

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9168709/

