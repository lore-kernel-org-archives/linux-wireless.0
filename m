Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5652 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbcGHGog (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 02:44:36 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] ath10k: remove unused <linux/semaphore.h>
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160621114539.15313-1-chaehyun.lim@gmail.com>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
CC: <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	Chaehyun Lim <chaehyun.lim@gmail.com>,
	<ath10k@lists.infradead.org>
Message-ID: <71b9d76a0a914d21adf71ca7493fa637@euamsexm01a.eu.qualcomm.com> (sfid-20160708_084439_290518_9FB711AB)
Date: Fri, 8 Jul 2016 08:44:28 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chaehyun Lim <chaehyun.lim@gmail.com> wrote:
> <linux/semaphore.h> is not used anymore, so just remove it.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

a3dadad73324 ath10k: remove unused <linux/semaphore.h>

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9190357/

