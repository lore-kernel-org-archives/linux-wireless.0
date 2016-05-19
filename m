Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400AbcESMk6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2016 08:40:58 -0400
Date: Thu, 19 May 2016 14:38:57 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlegacy: avoid warning about missing braces
Message-ID: <20160519123856.GA23657@redhat.com> (sfid-20160519_144123_599046_2230896A)
References: <1463644741-529379-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1463644741-529379-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 19, 2016 at 09:58:49AM +0200, Arnd Bergmann wrote:
> gcc-6 warns about code in il3945_hw_txq_ctx_free() being
> somewhat ambiguous:
> 
> drivers/net/wireless/intel/iwlegacy/3945.c:1022:5: warning: suggest explicit braces to avoid ambiguous 'else' [-Wparentheses]
> 
> This adds a set of curly braces to avoid the warning.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
