Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:26046 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbYLWU3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 15:29:40 -0500
Received: by fg-out-1718.google.com with SMTP id 19so1021139fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 12:29:38 -0800 (PST)
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH] Revert "iwl3945: remove iwl-3945-led.[ch]"
References: <1230000441-15977-1-git-send-email-yi.zhu@intel.com>
Date: Tue, 23 Dec 2008 22:29:34 +0200
In-Reply-To: <1230000441-15977-1-git-send-email-yi.zhu@intel.com> (Zhu Yi's message of "Tue\, 23 Dec 2008 10\:47\:21 +0800")
Message-ID: <877i5qd49d.fsf@litku.valot.fi> (sfid-20081223_212943_374964_ABA4CBE1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Kalle Valo <kalle.valo@iki.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zhu Yi <yi.zhu@intel.com> writes:

> This reverts commit b3489137ec7dabe4531c4344347270857301e209. This
> fixes the iwl3945 scan regression reported by Kalle Valo.
>
> Conflicts:
>
> 	drivers/net/wireless/iwlwifi/iwl3945-base.c

Yes, this fixes the scan crash. I applied this patch on top of the ten
patches you posted earlier this week and I could associate to my AP
again. Thank you for fixing this.

Noticed that your Signed-off-by line was missing.

Tested-by: Kalle Valo <kalle.valo@iki.fi>

-- 
Kalle Valo
