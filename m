Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60031 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbcFNO0i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 10:26:38 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: iwlegacy: avoid warning about missing braces
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1463644741-529379-1-git-send-email-arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-Id: <20160614142637.553336130F@smtp.codeaurora.org> (sfid-20160614_162700_009891_E1549158)
Date: Tue, 14 Jun 2016 14:26:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> wrote:
> gcc-6 warns about code in il3945_hw_txq_ctx_free() being
> somewhat ambiguous:
> 
> drivers/net/wireless/intel/iwlegacy/3945.c:1022:5: warning: suggest explicit braces to avoid ambiguous 'else' [-Wparentheses]
> 
> This adds a set of curly braces to avoid the warning.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

2cce76c3fab4 iwlegacy: avoid warning about missing braces

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9124661/

