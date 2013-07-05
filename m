Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32494 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757216Ab3GENYI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 09:24:08 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH v2] ath10k: fix MSI-X setup failpath
References: <1372150661-6862-1-git-send-email-michal.kazior@tieto.com>
	<1372229450-4575-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 5 Jul 2013 16:23:59 +0300
In-Reply-To: <1372229450-4575-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 26 Jun 2013 08:50:50 +0200")
Message-ID: <877gh5gmxc.fsf@kamboji.qca.qualcomm.com> (sfid-20130705_152412_737139_CE57DE74)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Irqs were not freed up correctly upon msi-x setup
> failure.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

John has already applied this.

-- 
Kalle Valo
