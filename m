Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:7488 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2KPLiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 06:38:25 -0500
Cc: <ath6kl-devel@qca.qualcomm.com>
Message-ID: <50A625A9.2050501@qca.qualcomm.com> (sfid-20121116_123828_412143_4DA40D95)
Date: Fri, 16 Nov 2012 13:38:17 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: support NL80211_USER_REG_HINT_CELL_BASE events
References: <20121116082804.10073.67557.stgit@localhost6.localdomain6>
In-Reply-To: <20121116082804.10073.67557.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/16/2012 10:28 AM, Kalle Valo wrote:
> As ath6kl firmware can't do intersections the driver should only listen
> to regdom changes from cellular base stations, all other requests need to
> be refused.
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Applied.

Kalle
